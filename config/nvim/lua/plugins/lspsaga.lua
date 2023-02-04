return {
  {
    "glepnir/lspsaga.nvim",
    enabled = false,
    event = "BufRead",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("lspsaga").setup({
        request_timeout = 60000, -- 1 min
        finder = {
          edit = { "o", "<CR>" },
          vsplit = "v",
          split = "s",
          tabe = "t",
          quit = { "q", "<ESC>" },
        },
        definition = {
          edit = "o",
          vsplit = "v",
          split = "s",
          tabe = "t",
          quit = "q",
          close = "<Esc>",
        },
        callhierarchy = {
          show_detail = false,
          keys = {
            edit = "o",
            vsplit = "v",
            split = "s",
            tabe = "t",
            jump = "e",
            quit = "q",
            expand_collapse = "u",
          },
        },
      })

      local map = require('configs.keymaps').map
      map('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>')
      map('n', 'gD', '<cmd>Lspsaga goto_definition<CR>')
      map('n', 'gd', '<cmd>Lspsaga peek_definition<CR>')
      map('n', 'gp', '<cmd>Lspsaga show_line_diagnostics<CR>')
      map('n', 'go', '<cmd>Lspsaga outline<CR>')
      map('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
      map('n', 'gI', '<cmd>Lspsaga incoming_calls<CR>')
      map('n', 'gO', '<cmd>Lspsaga outgoing_calls<CR>')
      map('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
      map('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>')
    end
  }
}
