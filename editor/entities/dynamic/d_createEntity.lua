function createEntityOnClick(STATE)
  print('open layer path callback')
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="Create Entity",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  update=function(self, STATE, t)
  end
}