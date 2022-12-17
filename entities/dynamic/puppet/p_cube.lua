puppets = require "../../lib/puppets"

local entityModes = {"TEST_MODE"}

local inputFunctions = {
  "up"=function() print("p_cube up") end,
  "down"=function() print("p_cube down") end,
  "left"=function() print("p_cube left") end,
  "right"=function() print("p_cube right") end,
}

function update(LEVEL, activeModes, activeInputs)
  print("p_cube updating")
  puppets.processInputs(
    inputFunctions, 
    inputFunctions, 
    entityModes, 
    activeModes, 
    activeInputs
  )
end

return {
  entityType="puppet",
  assetType="obj",
  asset="cube",
  transform={
    {1,0,0,0},
    {0,1,0,0},
    {0,0,1,0},
    {1,0,1,1}
  },
  color={0,0,0},
  input_modes=input_modes,
  update=function() update() end
}