return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        hover = {
          enabled = false
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true
      }
    }
  }
}
