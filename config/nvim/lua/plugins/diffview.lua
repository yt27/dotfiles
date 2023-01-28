return {
  {
    "sindrets/diffview.nvim",
    config = function()
      local map = require('configs.keymaps').map
      -- exclude untracked
      map('n', '<leader>do', '<cmd>DiffviewOpen -uno<cr>')
      -- all
      map('n', '<leader>dO', '<cmd>DiffviewOpen<cr>')

      map('n', '<leader>dh', '<cmd>DiffviewFileHistory<cr>')
      map('n', '<leader>dH', '<cmd>DiffviewFileHistory %<cr>')

      map('n', '<leader>dc', '<cmd>DiffviewClose<cr>')
    end
  }
}
