local M = {}

function M:setup()
  local nnoremap = require('keybindings').nnoremap
  nnoremap('<leader>tr', '<cmd>TroubleToggle<cr>')
end

return M
