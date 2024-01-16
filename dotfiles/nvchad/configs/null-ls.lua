local null_ls = require("null-ls")

local eslint_d = {
  extra_args = {
    '--no-eslintrc',
    '--no-error-on-unmatched-pattern',
    '--report-unused-disable-directives',
    '--config',
    vim.fn.expand('$HOME/BrandonProjects/js-metarepo/tooling/js-lint/src/js/config.cjs'),
    '--ext',
    '.js,.ts,.jsx,.mjs,.cjs,.tsx',
    '--cache'
  }
}

local M = {
  on_attach = function()
    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,

  sources = {
    -- javascript
    null_ls.builtins.code_actions.eslint_d.with(eslint_d),
    null_ls.builtins.diagnostics.eslint_d.with(eslint_d),
    null_ls.builtins.formatting.eslint_d.with(eslint_d),

    -- text
    null_ls.builtins.code_actions.ltrs,
    null_ls.builtins.diagnostics.ltrs,

    null_ls.builtins.code_actions.proselint,
    null_ls.builtins.diagnostics.proselint,

    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.diagnostics.alex,

    -- markdown
    -- null_ls.builtins.formatting.remark

    -- shell
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,

    -- github actions
    null_ls.builtins.diagnostics.actionlint,

    -- docker
    null_ls.builtins.diagnostics.hadolint,

    -- json
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.formatting.fixjson,

  }
}


null_ls.setup({
  on_attach = M.on_attach,
  sources = M.sources
})

return M;
