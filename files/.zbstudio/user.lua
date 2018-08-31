--[[--
  Use this file to specify **User** preferences.
  Review [examples](+/home/wheybags/Downloads/ZeroBraneStudio-1.70/cfg/user-sample.lua) or check [online documentation](http://studio.zerobrane.com/documentation.html) for details.
--]]--

styles = loadfile('cfg/tomorrow.lua')('Zenburn')
stylesoutshell = styles -- apply the same scheme to Output/Console windows
styles.auxwindow = styles.text -- apply text colors to auxiliary windows
styles.calltip = styles.text -- apply text colors to tooltips


local G = ...

keymap[G.ID_GOTODEFINITION] = "F2"
keymap[G.ID_COMMENT] = "Ctrl-/"
keymap[G.ID_NAVIGATETOFILE] = "Ctrl-K"
keymap[G.ID_AUTOCOMPLETE] = "Ctrl-Space"