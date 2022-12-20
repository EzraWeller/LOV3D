local textInputKey = "ProjectPath"

function projectPathOnClick(STATE)
  print('project path callback')
end

return {
  entityType="dynamic",
  assetType="text",
  dimensions="2D",
  asset={
    text="/",
    fontSize=12,
    bgColor={0,0,0,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=function(STATE) projectPathOnClick(STATE) end
  },
  transform={0, 0},
  update=function(self, STATE)
    self.asset.text = STATE.TEXT[textInputKey]
  end
}