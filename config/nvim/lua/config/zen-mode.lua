local M = {}

function M:setup()
  require('zen-mode').setup {
    window = {
      backdrop = 0.75, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      -- height and width can be:
      -- * an absolute number of cells when > 1
      -- * a percentage of the width / height of the editor when <= 1
      -- * a function that returns the width or the height
      width = 0.8, -- width of the Zen window
      height = 0.95, -- height of the Zen window
      -- by default, no options are changed for the Zen window
      -- uncomment any of the options below, or add other vim.wo options you want to apply
      options = {
        -- signcolumn = "no", -- disable signcolumn
        -- number = false, -- disable number column
        -- relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
      },
    }
  }

  local nnoremap = require('keybindings').nnoremap
  nnoremap('<leader>z', '<cmd>lua require(\'zen-mode\').toggle()<cr>')
end

return M
