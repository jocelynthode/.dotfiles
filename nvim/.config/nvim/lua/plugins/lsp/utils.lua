local M = {}

function M.lsp_format_on_save(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local LspFormatting = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_clear_autocmds({ group = LspFormatting, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = LspFormatting,
      buffer = bufnr,
      callback = vim.lsp.buf.formatting_sync,
    })
  end
end

return M
