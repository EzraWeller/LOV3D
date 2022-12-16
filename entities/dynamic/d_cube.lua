function update()
  print("d_cube updating")
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
  update=function() update() end
}