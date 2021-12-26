// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import { inject, injectable } from 'inversify'
import { languages, workspace } from 'coc.nvim'
import { DocumentFilter } from 'vscode-languageserver-protocol'
import { PYTHON } from '../common/constants'
import { IConfigurationService, IExtensionContext, Resource } from '../common/types'
import { IShebangCodeLensProvider } from '../interpreter/contracts'
import { IServiceContainer, IServiceManager } from '../ioc/types'
import { JediFactory } from '../languageServices/jediProxyFactory'
import { PythonCompletionItemProvider } from '../providers/completionProvider'
import { PythonDefinitionProvider } from '../providers/definitionProvider'
import { PythonHoverProvider } from '../providers/hoverProvider'
import { activateGoToObjectDefinitionProvider } from '../providers/objectDefinitionProvider'
import { PythonReferenceProvider } from '../providers/referenceProvider'
import { PythonRenameProvider } from '../providers/renameProvider'
import { PythonSignatureProvider } from '../providers/signatureProvider'
import { JediSymbolProvider } from '../providers/symbolProvider'
import { BlockFormatProviders } from '../typeFormatters/blockFormatProvider'
import { OnTypeFormattingDispatcher } from '../typeFormatters/dispatcher'
import { OnEnterFormatter } from '../typeFormatters/onEnterFormatter'
import { WorkspaceSymbols } from '../workspaceSymbols/main'
import { ILanguageServerActivator } from './types'

@injectable()
export class JediExtensionActivator implements ILanguageServerActivator {
  private readonly context: IExtensionContext
  private jediFactory?: JediFactory
  private readonly documentSelector: DocumentFilter[]
  private shortcut: string
  constructor(@inject(IServiceManager) private serviceManager: IServiceManager) {
    this.context = this.serviceManager.get<IExtensionContext>(IExtensionContext)
    this.documentSelector = PYTHON
    let config = workspace.getConfiguration('python')
    this.shortcut = config.get<string>('jediShortcut', 'JD')
  }

  public async activate(_resource: Resource): Promise<void> {
    if (this.jediFactory) {
      throw new Error('Jedi already started')
    }
    const context = this.context

    const jediFactory = (this.jediFactory = new JediFactory(context.asAbsolutePath('.'), this.serviceManager))
    context.subscriptions.push(jediFactory)
    context.subscriptions.push(...activateGoToObjectDefinitionProvider(jediFactory))

    context.subscriptions.push(jediFactory)
    context.subscriptions.push(
      languages.registerRenameProvider(this.documentSelector, new PythonRenameProvider(this.serviceManager))
    )
    const definitionProvider = new PythonDefinitionProvider(jediFactory)

    context.subscriptions.push(languages.registerDefinitionProvider(this.documentSelector, definitionProvider))
    context.subscriptions.push(
      languages.registerHoverProvider(this.documentSelector, new PythonHoverProvider(jediFactory))
    )
    context.subscriptions.push(
      languages.registerReferencesProvider(this.documentSelector, new PythonReferenceProvider(jediFactory))
    )
    context.subscriptions.push(
      languages.registerCompletionItemProvider(
        'jedi',
        this.shortcut,
        ['python'],
        new PythonCompletionItemProvider(jediFactory, this.serviceManager),
        ['.']
      )
    )
    context.subscriptions.push(
      languages.registerCodeLensProvider(
        this.documentSelector,
        this.serviceManager.get<IShebangCodeLensProvider>(IShebangCodeLensProvider)
      )
    )

    const onTypeDispatcher = new OnTypeFormattingDispatcher({
      '\n': new OnEnterFormatter(),
      ':': new BlockFormatProviders()
    })
    const onTypeTriggers = onTypeDispatcher.getTriggerCharacters()
    if (onTypeTriggers) {
      context.subscriptions.push(
        languages.registerOnTypeFormattingEditProvider(
          this.documentSelector,
          onTypeDispatcher,
          [onTypeTriggers.first, ...onTypeTriggers.more]
        )
      )
    }

    const serviceContainer = this.serviceManager.get<IServiceContainer>(IServiceContainer)
    context.subscriptions.push(new WorkspaceSymbols(serviceContainer))

    const symbolProvider = new JediSymbolProvider(serviceContainer, jediFactory)
    context.subscriptions.push(languages.registerDocumentSymbolProvider(this.documentSelector, symbolProvider))

    const pythonSettings = this.serviceManager.get<IConfigurationService>(IConfigurationService).getSettings()
    if (pythonSettings.devOptions.indexOf('DISABLE_SIGNATURE') === -1) {
      context.subscriptions.push(
        languages.registerSignatureHelpProvider(
          this.documentSelector,
          new PythonSignatureProvider(jediFactory),
          ['(', ',']
        )
      )
    }

    context.subscriptions.push(
      languages.registerRenameProvider(PYTHON, new PythonRenameProvider(serviceContainer))
    )
  }

  public dispose(): void {
    if (this.jediFactory) {
      this.jediFactory.dispose()
    }
  }
}
