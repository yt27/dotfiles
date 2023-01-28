local M = {}

function M:setup()
  local nnoremap = require('keybindings').nnoremap
  nnoremap('<leader>nt', '<cmd>NeoTreeReveal<cr>')
end

return M
