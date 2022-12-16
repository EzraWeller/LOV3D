local input_modes = {"TEST_MODE"}

local inputs = {
  "up"=function() print("p_cube up") end,
  "down"=function() print("p_cube down") end,
  "left"=function() print("p_cube left") end,
  "right"=function() print("p_cube right") end,
}

function update()
  print("p_cube updating")
  puppetInputs(inputs)
end

-- to separate lib
function puppetInputs(inputs)
  if shareElement(input_modes, INPUT_MODES) then
    for k, v in pairs(inputs) do
      if containsElement(k, INPUTS) then v() end
    end
  end
end

-- to separate lib
function shareElement(a1, a2)
  for i, v in ipairs(a1) do
    if containsElement(v, a2) then return true end
  end
  return false
end

-- to separate lib
function containsElement(e, a)
  for i, v in ipairs(a) do
    if e == v then 
      return true
    end
  end
  return false
end

return {
  dimensions="3",
  type="static",
  asset=require("../assets/obj/cube.obj"),
  transform={
    {1,0,0,0},
    {0,1,0,0},
    {0,0,1,0},
    {1,0,1,1}
  },
  input_modes=input_modes,
  update=function() update() end
}