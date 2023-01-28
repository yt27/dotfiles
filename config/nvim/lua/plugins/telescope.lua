return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "folke/trouble.nvim",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      -- To open result in Trouble
      -- https://github.com/folke/trouble.nvim
      local actions = require("telescope.actions")
      local trouble = require("trouble.providers.telescope")

      require("telescope").setup({
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble }
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        }
      })
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')

      local map = require('configs.keymaps').map
      map('n', '<space>tf', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>')
      map('n', '<space>tF', '<cmd>lua require(\'telescope.builtin\').git_files()<cr>')
      map('n', '<space>tg', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>')
      map('n', '<space>tG', '<cmd>lua require(\'telescope.builtin\').grep_string()<cr>')
      map('n', '<space>tb', '<cmd>lua require(\'telescope.builtin\').current_buffer_fuzzy_find()<cr>')
      map('n', '<space>tB', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>')
    end
  }
}
