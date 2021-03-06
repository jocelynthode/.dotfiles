local status_ok, impatient = pcall(require, "impatient")

if status_ok then
  impatient.enable_profile()
end

local core_modules = {
  "core.options",
  "core.plugins",
  "core.autocmds",
  "core.mappings",
}

for _, module in ipairs(core_modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
  end
end

require('base16-colorscheme').with_config {
  telescope = false,
}
vim.cmd [[colorscheme base16-gruvbox-dark-hard]]
vim.cmd [[hi Normal ctermbg=NONE guibg=NONE]]
