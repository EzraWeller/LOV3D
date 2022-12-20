local textInputKey = "LevelPath"

function levelPathOnClick(STATE)
  print('level path callback')
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="/",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=function(STATE) levelPathOnClick(STATE) end
  },
  transform={0, 0},
  update=function(self, STATE, t)
  end
}