local M = {}

function M.require_plugin(name)
  return string.format('require("plugins/%s")', name)
end

return M
