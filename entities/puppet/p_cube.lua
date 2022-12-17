puppets = require "lib/puppets"

local entityModes = {"TEST_MODE"}

local inputFunctions = {
  "up"=function(self, STATE) print("p_cube up") end,
  "down"=function(self, STATE) print("p_cube down") end,
  "left"=function(self, STATE) print("p_cube left") end,
  "right"=function(self, STATE) print("p_cube right") end,
}

function update(self, STATE)
  print("p_cube updating")
  puppets.processInputs( 
    self,
    STATE,
    inputFunctions, 
    entityModes, 
    STATE.INPUT_MODES, 
    STATE.ACTIVE_INPUTS
  )
  return self
end

return {
  entityType="puppet",
  assetType="obj",
  dimensions="3D",
  asset="cube",
  transform={
    {1,0,0,0},
    {0,1,0,0},
    {0,0,1,0},
    {1,0,1,1}
  },
  color={0,0,0},
  input_modes=input_modes,
  update=function(self, STATE) update(self, STATE) end
}