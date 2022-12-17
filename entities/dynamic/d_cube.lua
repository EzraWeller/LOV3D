function update(self, LEVEL)
  print("d_cube updating")
  -- placeholder
  return self
end

return {
  entityType="dynamic",
  assetType="obj",
  asset="cube",
  transform={
    {1,0,0,0},
    {0,1,0,0},
    {0,0,1,0},
    {1,0,1,1}
  },
  color={0,0,0},
  update=function() update() end
}