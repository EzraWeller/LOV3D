puppets = require "../../lib/puppets"

local input_modes = {"TEST_MODE"}

local inputs = {
  "up"=function() print("p_cube up") end,
  "down"=function() print("p_cube down") end,
  "left"=function() print("p_cube left") end,
  "right"=function() print("p_cube right") end,
}

function update()
  print("p_cube updating")
  puppets.processInputs(inputs)
end

return {
  dimensions="3",
  type="puppet",
  asset=require "../assets/obj/cube.obj",
  transform={
    {1,0,0,0},
    {0,1,0,0},
    {0,0,1,0},
    {1,0,1,1}
  },
  input_modes=input_modes,
  update=function() update() end
}