return {
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        use_diagnostic_signs = true
      })

      local map = require('configs.keymaps').map
      map('n', '<leader>tr', '<cmd>TroubleToggle<cr>')
    end
  }
}
