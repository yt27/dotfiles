return {
  {
    "hrsh7th/vim-vsnip",
    config = function()
      local map = require('configs.keymaps').map
      -- imap <expr> \<Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
      -- smap <expr> \<Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
      -- imap <expr> \<S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
      -- smap <expr> \<S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
    end
  }
}
