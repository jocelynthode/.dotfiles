local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local utils = require("user.lsp.utils")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "markdown", "graphql", "handlebars" }
    }),
    code_actions.gitsigns,
    diagnostics.gitlint,
    -- Shell
    formatting.shfmt,
    diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
    -- Python
    formatting.black,
    diagnostics.flake8,
  },
  on_attach = utils.lsp_format_on_save,
})
