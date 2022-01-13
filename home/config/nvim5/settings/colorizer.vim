" Is Apple_Terminal
let isAppleTerminal = $TERM_PROGRAM == "Apple_Terminal"

" Colorizer
if !isAppleTerminal
  lua require'colorizer'.setup()
endif
