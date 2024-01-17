local M = {
  settings = {
    --  hhttps://github.com/pmizio/typescript-tools.nvim/blob/master/lua/typescript-tools/config.lua#L17
    tsserver_format_options = {
      insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
      insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
      insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
    }
  }
}


require("typescript-tools").setup(M);

return M;
