return {
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end
      })

      local map = require('configs.keymaps').map
      map("n", "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end)
    end
  }
}
