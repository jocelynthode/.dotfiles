local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local LspFormatting = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.stylua,
		code_actions.gitsigns,
		diagnostics.gitlint,
		diagnostics.yamllint,
		-- Shell
		formatting.shfmt,
		diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
		-- Python
		formatting.black,
		diagnostics.flake8,
		-- Terraform
		formatting.terraform_fmt,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = LspFormatting, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = LspFormatting,
				buffer = bufnr,
				callback = vim.lsp.buf.formatting_sync,
			})
		end
	end,
})
