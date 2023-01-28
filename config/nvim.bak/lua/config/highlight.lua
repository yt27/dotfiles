local M = {}

function M:setup()
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = "#2a2b36" })
end

return M
