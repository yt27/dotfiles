local M = {}

function M:setup()
  local nnoremap = require('keybindings').nnoremap
  -- exclude untracked
  nnoremap('<leader>do', '<cmd>DiffviewOpen -uno<cr>')
  -- all
  nnoremap('<leader>dO', '<cmd>DiffviewOpen<cr>')

  nnoremap('<leader>dh', '<cmd>DiffviewFileHistory<cr>')
  nnoremap('<leader>dH', '<cmd>DiffviewFileHistory %<cr>')

  nnoremap('<leader>dc', '<cmd>DiffviewClose<cr>')
end

return M
