local M = {
  settings = {
    tsserver_format_options = {
      insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
      insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
    }
  }
}


require("typescript-tools").setup(M);

return M;
