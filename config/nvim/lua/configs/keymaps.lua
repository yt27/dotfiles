local M = {}

function M.nnoremap(mappedKeys, mapping, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap('n', mappedKeys, mapping, options)
end

function M.tnoremap(mappedKeys, mapping, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap('t', mappedKeys, mapping, options)
end

function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M:setup()
  M.map('i', 'jk', '<esc>')
  M.map('i', 'kj', '<esc>')

  M.map('n', 'j', 'gj')
  M.map('n', 'k', 'gk')
  M.map('n', 'gj', 'j')
  M.map('n', 'gk', 'k')

  M.map('n', '<leader>tn', '<cmd>tabnew<cr>')
  M.map('n', '<leader>tc', '<cmd>tabclose<cr>')

  M.map('n', '<leader>wq', '<cmd>quit<cr>')
  M.map('n', '<leader>ww', '<cmd>write<cr>')

  M.map('n', '<leader>s', '<cmd>set spell!<cr>')

  M.map('n', '<cr>', '<cmd>nohlsearch<cr>')
end

return M
