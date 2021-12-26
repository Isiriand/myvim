set background=dark

highlight clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "DarkModeReloaded"
"--------------------------------------------------------------------------------------------------------------------------------------------------
" Color Palette                                             " Syntax-group
"--------------------------------------------------------------------------------------------------------------------------------------------------
let s:SpanishRoast                  = { "gui": "#222d33" }  " Comment
let s:Dark                          = { "gui": "#141c1f" }  " Visual
let s:PurplHeart                    = { "gui": "#6628A4" }  " Directory
let s:MiddleYellow                  = { "gui": "#FFEA00" }  " Warning
let s:BlackKnightDark               = { "gui": "#0c1012" }  " Background, TabLineSel
let s:SpanishRoastDark              = { "gui": "#141b1f" }  " TabLineFill
let s:NewPortBlue                   = { "gui": "#208FC5" }  " Search, LineNr, Identifier
let s:FirebrickLight                = { "gui": "#E0463E" }  " ErrorMsg, DiffDelete
let s:Firebrick                     = { "gui": "#D32B22" }  " Error
let s:VibrantGreenLight             = { "gui": "#00FF11" }  " SpecialKey, Diffadd
let s:GlacialIce                    = { "gui": "#EAE9E8" }  " CursorLineNr
let s:ApprovalGreen                 = { "gui": "#00877A" }  " Brackets
let s:IllustratiousIndigo           = { "gui": "#F44336" }  " Operator
let s:Flirtatious                   = { "gui": "#FDD835" }  " Function
let s:SeaFantasy                    = { "gui": "#19A194" }  " MatchParen
let s:White                         = { "gui": "#FFFFFF" }  " Forground
let s:AbyssalDepths                 = { "gui": "#253137" }  " TabLine, TabLineFill
let s:BlackWash                     = { "gui": "#0A0C0F" }  " Pmenu
let s:BlackWashLight                = { "gui": "#16181B" }  " PmenuSel
let s:IslandGreen                   = { "gui": "#27AE60" }  " Constant
let s:OrangeGluttony                = { "gui": "#E67E22" }  " String, Character
let s:TannedLeather                 = { "gui": "#F1C40F" }  " Number, Float
let s:Aloha                         = { "gui": "#1ABC9C" }  " Boolean
let s:IllustriousIndigo             = { "gui": "#512BA8" }  " Statement, Conditional, Repeat, Label, Keyword, Exception
let s:MellowMelon                   = { "gui": "#E91E63" }  " PreProc, Define, Include, Macro, PreCondit
let s:LexaloffleGreen               = { "gui": "#00E031" }  " Type 
let s:ImpressionOfObscurity         = { "gui": "#1A237E" }  " StorageClass
let s:FrightNight                   = { "gui": "#0D47A1" }  " Structure 
let s:Carnelian                     = { "gui": "#B71C1C" }  " Typedef 
let s:Dayflower                     = { "gui": "#3599DB" }  " SpecialChar 
let s:AzureTide                     = { "gui": "#28978C" }  " Delimiter 
"--------------------------------------------------------------------------------------------------------------------------------------------------
function! s:h(group, fg, bg, attr)
  if type(a:fg) == type({})
    exec "hi " . a:group . " guifg=" . a:fg.gui
  else
    exec "hi " . a:group . " guifg=NONE"
  endif
  if type(a:bg) == type({})
    exec "hi " . a:group . " guibg=" . a:bg.gui
  else"
    exec "hi " . a:group . " guibg=NONE"
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr
  else
    exec "hi " . a:group . " gui=NONE"
  endif
endfunction


"----------------------------------------------------------------------------------------------------------------------------------
" Improved highlight function
function s:HI(group, guifg, guibg, attr, guisp)
  if type(a:guifg) == type({})
    exec "hi " . a:group . " guifg=" . a:guifg.gui
  else
    exec "hi " . a:group . " guifg=NONE"
  endif


  if type(a:guibg) == type({})
    exec "hi " . a:group . " guibg=" . a:guibg.gui
  else"
    exec "hi " . a:group . " guibg=NONE"
  endif


  if type(a:attr) == type([])
    if len(a:attr) == 2
      exec "hi " . a:group . " gui=" . a:attr[0] . "," . a:attr[1]
    endif
    if len(a:attr) == 1
      exec "hi " . a:group . " gui=" . a:attr[0]
    endif
  else
    exec "hi " . a:group . " gui=NONE"
  endif


  if type(a:guisp) == type({})
    exec "hi " . a:group . " guisp=" . a:guisp.gui
  else
    exec "hi " . a:group . " guisp=NONE" 
  endif
endfunction

"--------------------------------------------------------------------------------------------------------------------------------------------------

call s:h("Normal", s:White, s:BlackKnightDark, "")
call s:h("Visual", "", s:Dark, "")

call s:h("LineNr", s:NewPortBlue, s:BlackKnightDark, "")
call s:h("CursorLineNr", s:GlacialIce, "", "bold")

call s:h("MatchParen", s:SeaFantasy, "", "")
call s:h("Search", s:BlackKnightDark, s:NewPortBlue, "underline")

call s:h("ErrorMsg", s:Firebrick, "", "")
call s:h("WarningMsg", s:MiddleYellow, "", "")

call s:h("WildMenu", s:GlacialIce, "", "")
call s:h("Pmenu", s:GlacialIce, s:BlackWash, "")
call s:h("PmenuSel", s:GlacialIce, s:BlackWashLight, "")
call s:h("PmenuSbar", s:GlacialIce, "", "")
call s:h("PmenuThumb", s:GlacialIce, "", "")

call s:h("Comment", s:SpanishRoast, "", "Italic,bold")
call s:h("SpecialComment", s:AbyssalDepths, "", "")

call s:h("TabLine", s:GlacialIce, s:AbyssalDepths, "underline")
call s:h("TabLineSel", s:GlacialIce, s:BlackKnightDark, "")
call s:h("TabLineFill", s:GlacialIce, s:SpanishRoastDark, "underline")

call s:h("VertSplit", s:SpanishRoast, s:BlackKnightDark, "")

call s:h("Diffadd", s:VibrantGreenLight, s:BlackKnightDark, "bold")
call s:h("DiffDelete", s:FirebrickLight, s:BlackKnightDark, "bold")
call s:h("DiffChange", s:SpanishRoast, s:BlackKnightDark, "bold")
call s:h("SignColumn", "", s:BlackKnightDark, "bold")

call s:h("Bold", "", "", "bold")
call s:h("Underlined", "", "", "undercurl")
call s:h("Italic", "", "", "italic")
call s:h("Ignore", "", "", "")
call s:HI("Error", "", "", ["undercurl"], s:Firebrick)

call s:h("SpecialKey", s:VibrantGreenLight, "", "")
call s:h("Directory", s:PurplHeart, "", "")

call s:h("Constant", s:IslandGreen, "", "")
call s:h("String", s:OrangeGluttony, "", "")
call s:h("Chatacter", s:OrangeGluttony, "", "")
call s:h("Number", s:TannedLeather, "", "")
call s:h("Boolean", s:IslandGreen, "", "")
call s:h("Float", s:Aloha, "", "")

call s:h("Identifier", s:NewPortBlue, "", "")
call s:h("Function", s:Flirtatious, "", "bold")
call s:h("Operator", s:IllustratiousIndigo, "", "")

call s:h("Statement", s:IllustratiousIndigo, "", "")
call s:h("Conditional", s:IllustratiousIndigo, "", "")
call s:h("Repeat", s:IllustratiousIndigo, "", "")
call s:h("Label", s:IllustratiousIndigo, "", "")
call s:h("Keyword", s:IllustratiousIndigo, "", "")
call s:h("Exception", s:IllustratiousIndigo, "", "")

call s:h("PreProc", s:MellowMelon, "", "")
call s:h("Include", s:MellowMelon, "", "")
call s:h("Define", s:MellowMelon, "", "")
call s:h("Macro", s:MellowMelon, "", "")
call s:h("PreCondit", s:MellowMelon, "", "")

call s:h("Type", s:LexaloffleGreen, "", "")
call s:h("StorageClass", s:ImpressionOfObscurity, "", "")
call s:h("Structure", s:FrightNight, "", "")
call s:h("Typedef", s:Carnelian, "", "")

call s:h("SpecialChar", s:Dayflower, "", "")
call s:h("Delimiter", s:AzureTide, "", "")

" Coc 
"--------------------------------------------------------------------------------------------------------------------------------------------------
hi def link CocErrorFloat WildMenu
hi def link CocWarningFloat WildMenu
hi def link CocInfoFloat WildMenu
hi def link CocHintFloat WildMenu

hi def link CocErrorHighlight Error
hi def link CocWarningHighlight Error
hi def link CocInfoHighlight Error
