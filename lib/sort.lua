local sort = {}

function sort.counting(table, key, maxValue)
  local count = {}
  for i=1,maxValue + 1 do count[i] = 0 end

  local output = {}
  local value = 0

  -- histogram of key-values in table
  for i=1,#table do 
    value = math.floor(table[i][key]) + 1
    count[value] = count[value] + 1
  end

  -- prefix sum to convert histogram into order
  for i=1,#count do 
    if i ~= 1 then
      count[i] = count[i] + count[i - 1]
    end
  end

  -- order table items in output
  for i=#table, 1, -1 do 
    value = math.floor(table[i][key]) + 1
    output[count[value]] = table[i]
  end

  return output
end

return sort