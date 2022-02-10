-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local homeDir = '/Users/ytakebuc'

local javaHome = '/Library/Java/JavaVirtualMachines/jdk11.0.8-msft.jdk/Contents/Home'
local jdtlsHome = homeDir .. '/local/jdtls-1.5.0'

local javaPath = javaHome .. '/bin/java'
local jdtlsLauncherPath = jdtlsHome .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'
local jdtlsConfigPath = jdtlsHome .. '/config_mac'

local projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h')
local workspaceDir = homeDir .. '/workspace-root/' .. projectName

local lombokJarPath = homeDir .. '/local/jar/lombok-1.18.22.jar'

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    javaPath, -- or '/path/to/java11_or_newer/bin/java'
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

    '-javaagent:' .. lombokJarPath,

    '-jar', jdtlsLauncherPath,

    '-configuration', jdtlsConfigPath,

    -- See `data directory configuration` section in the README
    '-data', workspaceDir
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

  on_attach = require('keybindings').lspOnAttachCallback(),

  capabilities = capabilities
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
