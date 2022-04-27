local M = {}

function M:setup()
  -- You dont need to set any of these options. These are the default ones. Only
  -- the loading is important
  require('telescope').setup {
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      }
    }
  }
  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  require('telescope').load_extension('fzf')

  local nnoremap = require('keybindings').nnoremap
  nnoremap('<space>tf', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>')
  nnoremap('<space>tF', '<cmd>lua require(\'telescope.builtin\').git_files()<cr>')
  nnoremap('<space>tg', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>')
  nnoremap('<space>tG', '<cmd>lua require(\'telescope.builtin\').grep_string()<cr>')
  nnoremap('<space>tb', '<cmd>lua require(\'telescope.builtin\').current_buffer_fuzzy_find()<cr>')
  nnoremap('<space>tB', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>')
end

return M
