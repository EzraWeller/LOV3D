local inputTextKey="LevelPath"
local inputModes = {"game"}

local inputFunctions = {
  keyboard = {
    right=function(self) setLevelPathToNextLevel() end
  }
}

local function onClick(self)
  setLevelPathToNextLevel()
end

function setLevelPathToNextLevel()
  local levelIndex = arrays.indexOf(STATE.INPUT_TEXT[inputTextKey], STATE.PROJECT.levels)
  if levelIndex ~= nil and #STATE.PROJECT.levels > levelIndex then
    STATE.INPUT_TEXT[inputTextKey] = STATE.PROJECT.levels[levelIndex + 1]
  end
end

local function update(self)
  clicked.update(self)
  puppet.processInputs(self)
end

return {
  entityType="puppet",
  assetType="UI",
  dimensions="2D",
  asset={
    text="-->",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  shape="rectangle",
  transform={0, 0},
  onClick=onClick,
  otherClick=otherClick,
  update=update,
  inputTextKey=inputTextKey,
  inputModes=inputModes,
  inputFunctions=inputFunctions
}