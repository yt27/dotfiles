local M = {}

function M:setup()
  -- Commenting out for now as this seem to not apply syntax highlights etc.
  -- vim.api.nvim_create_autocmd("VimEnter", {
  --   callback = function()
  --     if vim.fn.argc() == 0 then
  --       require("persistence").load()
  --     end
  --   end,
  -- })

  -- From https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
  -- go to last loc when opening a buffer
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })
end

return M
