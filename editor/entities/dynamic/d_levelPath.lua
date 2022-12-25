-- should just update text to the current level path selected

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="/",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  shape="rectangle",
  transform={0, 0},
  update=function(self)
  end
}