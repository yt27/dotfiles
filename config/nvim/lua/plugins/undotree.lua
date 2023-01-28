return {
  {
    "mbbill/undotree",
    config = function()
      local map = require('configs.keymaps').map
      map('n', '<leader>ut', '<cmd>UndotreeToggle<cr>')
    end
  }
}
