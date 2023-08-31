return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- One of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = "all",

        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- List of parsers to ignore installing
        ignore_install = {},

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = {},

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },

        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["am"] = { query = "@function.outer", desc = "Select a method" },
              ["im"] = { query = "@function.inner", desc = "Select inner part of a method" },
              ["ac"] = { query = "@class.outer", desc = "Select a class" },
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },

              ["aa"] = { query = "@parameter.outer", desc = "Select a argument" },
              ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a argument" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            -- include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = { query = "@function.outer", desc = "Next method start" },
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
              -- ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              -- ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },

              ["]b"] = { query = "@block.outer", desc = "Next block start" },
              ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
              ["]r"] = { query = "@return.outer", desc = "Next return start" }
            },
            goto_next_end = {
              ["]M"] = { query = "@function.outer", desc = "Next method end" },
              ["]["] = { query = "@class.outer", desc = "Next class end" },

              ["]B"] = { query = "@block.outer", desc = "Next block end" },
              ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
              ["]R"] = { query = "@return.outer", desc = "Next return end" }
            },
            goto_previous_start = {
              ["[m"] = { query = "@function.outer", desc = "Previous method start" },
              ["[["] = { query = "@class.outer", desc = "Previous class start" },

              ["[b"] = { query = "@block.outer", desc = "Previous block start" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
              ["[r"] = { query = "@return.outer", desc = "Previous return start" }
            },
            goto_previous_end = {
              ["[M"] = { query = "@function.outer", desc = "Previous method end" },
              ["[]"] = { query = "@class.outer", desc = "Previous class end" },

              ["[B"] = { query = "@block.outer", desc = "Previous block end" },
              ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
              ["[R"] = { query = "@return.outer", desc = "Previous return end" }
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            -- goto_next = {
            --   ["]b"] = "@block.outer",
            -- },
            -- goto_previous = {
            --   ["[b"] = "@block.outer",
            -- }
          },
        },
      })
    end
  }
}
