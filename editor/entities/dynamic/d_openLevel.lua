function openLevelOnClick(STATE)
  print('open level callback')
end

return {
  entityType="dynamic",
  assetType="button",
  dimensions="2D",
  asset={
    text="Open Level",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=function(STATE) openLevelOnClick(STATE) end
  },
  transform={0, 0},
  update=function(self, STATE)
    self.asset.text = STATE.TEXT[textInputKey]
  end
}