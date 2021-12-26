// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

'use strict'

import { Terminal, Uri } from 'coc.nvim'
import { createDeferred, sleep } from '../../utils/async'
import { ITerminalActivator, ITerminalHelper, TerminalShellType } from '../types'

export class BaseTerminalActivator implements ITerminalActivator {
  private readonly activatedTerminals: Map<Terminal, Promise<boolean>> = new Map<Terminal, Promise<boolean>>()
  constructor(private readonly helper: ITerminalHelper) { }
  public async activateEnvironmentInTerminal(terminal: Terminal, resource: Uri | undefined, preserveFocus = true) {
    if (this.activatedTerminals.has(terminal)) {
      return this.activatedTerminals.get(terminal)!
    }
    const deferred = createDeferred<boolean>()
    this.activatedTerminals.set(terminal, deferred.promise)
    const shellPath = this.helper.getTerminalShellPath()
    const terminalShellType = !shellPath || shellPath.length === 0 ? TerminalShellType.other : this.helper.identifyTerminalShell(shellPath)

    const activationCommamnds = await this.helper.getEnvironmentActivationCommands(terminalShellType, resource)
    let activated = false
    if (activationCommamnds) {
      for (const command of activationCommamnds!) {
        terminal.show(preserveFocus)
        terminal.sendText(command)
        await this.waitForCommandToProcess(terminalShellType)
        activated = true
      }
    }
    deferred.resolve(activated)
    return activated
  }
  protected async waitForCommandToProcess(_shell: TerminalShellType) {
    // Give the command some time to complete.
    // Its been observed that sending commands too early will strip some text off in VS Code Terminal.
    await sleep(500)
  }
}