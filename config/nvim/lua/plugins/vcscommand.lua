return {
  {
    "vim-scripts/vcscommand.vim",
    config = function()
      local map = require('configs.keymaps').map
      map('n', '<space>vd', '<cmd>VCSDiff<cr>')
      map('n', '<space>vl', '<cmd>VCSLog<cr>')
    end
  }
}
