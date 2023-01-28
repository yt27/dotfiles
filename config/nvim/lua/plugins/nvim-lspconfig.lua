return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local nvim_lsp = require('lspconfig')
      local servers = { 'pyright' }
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = require('configs.keymaps').lspOnAttachCallback(),
          capabilities = capabilities
        }
      end
    end
  }
}
