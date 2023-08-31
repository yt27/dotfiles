if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  require("configs.autocmds").setup()
  require("configs.keymaps").setup()
  require("configs.options").setup()

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      -- import/override with your plugins
      { import = "plugins" },
      -- import any extras modules here
      -- { import = "lazyvim.plugins.extras.lang.typescript" },
      -- { import = "lazyvim.plugins.extras.lang.json" },
      -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    },
    defaults = {
      -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { "everforest" } },
    checker = { enabled = true }, -- automatically check for plugin updates
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })

  -- load session if started without args
  if vim.fn.argc() == 0 then
    require("persistence").load()
  end

  -- Different color for active window/buffer
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = "#353c43" })
end
