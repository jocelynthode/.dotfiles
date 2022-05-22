local function time_input()
  local time = os.time()
  local approx_time = time - (time % 900) + 900
  return os.date("%H:%M", approx_time)
end

return {
  s("ts", { i(1), t(" "), i(2, time_input()), t("-"), i(3, time_input()), t(" "), i(4), }),
}
