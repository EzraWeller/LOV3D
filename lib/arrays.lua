local arrays = {}
  
function arrays.shareElement(a1, a2)
  for i, v in ipairs(a1) do
    if arrays.containsElement(v, a2) then return true end
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

function arrays.addUniqueElement(a, e)
  if arrays.containsElement(e, a) then return false end
  table.insert(a, e)
  return true
end

function arrays.removeUniqueElement(a, e)
  if arrays.containsElement(e, a) == false then return false end
  for i, v in ipairs(a) do
    if v == a then
      table.remove(i)
      return true
    end
  end
end

return arrays