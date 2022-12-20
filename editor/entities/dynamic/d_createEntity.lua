function createEntityOnClick(STATE)
  print('open layer path callback')
  STATE.INPUT_MODES.typing = true
  STATE.INPUT_MODES.camera = false
  STATE.TEXT_INPUT_KEY = textInputKey
end

return {
  entityType="dynamic",
  assetType="button",
  dimensions="2D",
  asset={
    text="Create Entity",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=function(STATE) createEntityOnClick(STATE) end
  },
  transform={0, 0},
  update=function(self, STATE)
    self.asset.text = STATE.TEXT[textInputKey]
  end
}