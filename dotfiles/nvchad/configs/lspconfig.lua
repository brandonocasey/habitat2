local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
-- tsserver is handled by typescript-tools.nvim, see plugins.lua
local servers = { "html", "cssls", "typos_lsp" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.stylelint_lsp.setup({
  filetypes = { "css", "scss" },
  root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
  settings = {
    stylelintplus = {
     autoFixOnFormat = true,
      configFile = vim.fn.expand('$HOME/BrandonProjects/js-metarepo/tooling/css-lint/src/js/config.cjs')
    },
  },
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
  end,
})
