local _text = vim.api.nvim_create_augroup("_text", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "text", "markdown", "gitcommit" },
	callback = function()
		vim.api.nvim_command("setlocal spell")
		vim.api.nvim_command("setlocal wrap")
	end,
	group = _text,
})
-------------------

local _general_settings = vim.api.nvim_create_augroup("_general_settings", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "fugitive" },
	command = "nnoremap <silent> <buffer> q :close<CR>",
	group = _general_settings,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		require("vim.highlight").on_yank({ higroup = "Visual", timeout = 200 })
	end,
	group = _general_settings,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "*" },
	command = "set formatoptions-=cro",
	group = _general_settings,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf" },
	command = "set nobuflisted",
	group = _general_settings,
})
-------------------

local _auto_resize = vim.api.nvim_create_augroup("_auto_resize", { clear = true })

vim.api.nvim_create_autocmd({ "VimResized" }, {
	pattern = { "*" },
	command = "tabdo wincmd =",
	group = _auto_resize,
})
