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

vim.cmd [[colorscheme gruvbox]]
-- vim.cmd [[colorscheme dracula]]
