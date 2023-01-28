return {
  {
    "tpope/vim-fugitive",
    config = function()
      local map = require('configs.keymaps').map
      map('n', '<leader>gl', '<cmd>Glog<cr>')
      map('n', '<leader>gs', '<cmd>Git<cr>')
      map('n', '<leader>gb', '<cmd>Git blame<cr>')
      map('n', '<leader>gr', '<cmd>Gread<cr>')
      map('n', '<leader>gd', '<cmd>Gvdiff<cr>')
    end
  }
}
