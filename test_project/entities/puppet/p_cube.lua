local inputModes = {"game"}

local inputFunctions = {
  held = {},
  presses = {
    keyboard = {
      up=function(self) print("p_cube up") end,
      down=function(self) print("p_cube down") end,
      left=function(self) print("p_cube left") end,
      right=function(self) print("p_cube right") end
    }
  }
}

function update(self)
  print("p_cube updating")
  puppet.processInputs(self)
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
  inputFunctions=inputFunctions,
  inputModes=inputModes,
  update=update
}