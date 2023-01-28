return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim"
    },
    config = function()
      local map = require('configs.keymaps').map
      map("n", "<leader>nt", "<cmd>NeoTreeReveal<cr>")
    end
  }
}
