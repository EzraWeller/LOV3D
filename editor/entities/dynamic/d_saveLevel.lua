local textInputKey = "OpenLevelPath"

function OpenLevelPathOnClick(STATE)
  print('open layer path callback')
  STATE.INPUT_MODES.typing = true
  STATE.INPUT_MODES.camera = false
  STATE.TEXT_INPUT_KEY = textInputKey
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="/",
    fontSize=12,
    bgColor={0,0,0,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=function(STATE) OpenLevelPathOnClick(STATE) end
  },
  transform={0, 0},
  update=function(self, STATE, t)
  end
}