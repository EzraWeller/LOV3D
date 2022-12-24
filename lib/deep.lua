local deep = {}

function deep.copy(t)
  if type(t) ~= "table" then return t end
  local c = {}
  for k, v in pairs(t) do c[k] = deep.copy(v) end
  return c
end

return deep