" Is Apple_Terminal
let isAppleTerminal = $TERM_PROGRAM == "Apple_Terminal"

if !isAppleTerminal
  set termguicolors
  " Material -- SETTINGS
  let g:material_style = 'darker'
  colorscheme material
endif