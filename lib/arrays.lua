local arrays = {}
  
function arrays.shareElement(a1, a2)
  for i, v in ipairs(a1) do
    if containsElement(v, a2) then return true end
  end
  return false
end
  
function arrays.containsElement(e, a)
  for i, v in ipairs(a) do
    if e == v then 
      return true
    end
  end
  return false
end

return arrays