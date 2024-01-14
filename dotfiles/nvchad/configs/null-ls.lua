local null_ls = require("null-ls")

-- TODO: pass config https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
local options = {
  sources = {
    -- javascript
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.eslint_d,

    -- text
    null_ls.builtins.code_actions.ltrs,
    null_ls.builtins.diagnostics.ltrs,

    null_ls.builtins.code_actions.proselint,
    null_ls.builtins.diagnostics.proselint,

    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.diagnostics.alex,

    null_ls.builtins.diagnostics.codespell,
    null_ls.builtins.formatting.codespell,

    -- css
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.formatting.stylelint,

    -- markdown
    -- null_ls.builtins.formatting.remark

    -- shell
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.formatting.shellcheck,

    -- github actions
    null_ls.builtins.diagnostics.actionlint,

    -- docker
    null_ls.builtins.diagnostics.hadolint,

    -- json
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.formatting.fixjson,

    -- html
    null_ls.builtins.diagnostics.tidy,
    null_ls.builtins.formatting.tidy,

  }
}

return options

