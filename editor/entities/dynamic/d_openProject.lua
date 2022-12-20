function openProjectOnClick(STATE)
  print('open project callback')
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="Open Project",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=function(STATE) openProjectOnClick(STATE) end
  },
  transform={0, 0},
  update=function(self, STATE, t)
  end
}