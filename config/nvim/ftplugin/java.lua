-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local java_home = '/Library/Java/JavaVirtualMachines/jdk11.0.8-msft.jdk/Contents/Home'
local jdtls_home = '/Users/ytakebuc/local/jdtls-1.5.0'

local java_path = java_home .. '/bin/java'
local jdtls_launcher_path = jdtls_home .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'
local jdtls_config_path = jdtls_home .. '/config_mac'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h')
local workspace_dir = '/Users/ytakebuc/workspace-root/' .. project_name

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    java_path, -- or '/path/to/java11_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', jdtls_launcher_path,

    '-configuration', jdtls_config_path,

    -- See `data directory configuration` section in the README
    '-data', workspace_dir
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  on_attach = require('keybindings').lspOnAttachCallback()
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
