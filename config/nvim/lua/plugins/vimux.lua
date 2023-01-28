return {
  {
    "preservim/vimux",
    config = function()
      -- " Hack to fix issue running command when in copy-mode
      vim.g.VimuxResetSequence = '-X cancel'

      local map = require('configs.keymaps').map
      -- Prompt for a command to run
      map('n', '<Leader>vp', '<cmd>VimuxPromptCommand<cr>')

      -- Run last command executed by VimuxRunCommand
      map('n', '<Leader>vl', '<cmd>VimuxRunLastCommand<cr>')

      -- Inspect runner pane
      map('n', '<Leader>vi', '<cmd>VimuxInspectRunner<cr>')

      -- Open vim tmux runner
      map('n', '<Leader>vo', '<cmd>call VimuxOpenRunner()<cr>')

      -- Close vim tmux runner opened by VimuxRunCommand
      map('n', '<Leader>vq', '<cmd>VimuxCloseRunner<cr>')

      -- Interrupt any command running in the runner pane
      map('n', '<Leader>vx', '<cmd>VimuxInterruptRunner<cr>')

      -- Zoom the runner pane (use <bind-key> z to restore runner pane)
      map('n', '<Leader>vz', '<cmd>call VimuxZoomRunner()<cr>')
    end
  }
}
