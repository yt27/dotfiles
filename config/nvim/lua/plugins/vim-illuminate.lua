return {
  -- the colorscheme should be available when starting Neovim
  {
    "RRethy/vim-illuminate",
    config = function()
      local map = require('configs.keymaps').map
      map('n', '<leader>in', '<cmd>IlluminationToggle<cr>')
    end
  }
}
