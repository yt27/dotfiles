local M = {}

function M:setup()
  require'shade'.setup({
    overlay_opacity = 40
  })
end

return M
