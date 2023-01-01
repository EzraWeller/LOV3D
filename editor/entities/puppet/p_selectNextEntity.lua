local inputTextKey="EntityPath"
local inputModes = {"game"}

local inputFunctions = {
  held = {},
  presses = {
    keyboard = {
      x=function(self)
        project.selectNextEntityPath() 
        STATE.INPUT_TEXT[self.inputTextKey] = STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE][STATE.SELECTED_ENTITY_INDEX]
      end
    }
  }
}

local function onClick(self)
  print('next entity clicked')
  project.selectNextEntityPath()
  STATE.INPUT_TEXT[self.inputTextKey] = STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE][STATE.SELECTED_ENTITY_INDEX]
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
    text="x -->",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  shape="rectangle",
  transform={0, 0},
  onClick=onClick,
  update=update,
  inputTextKey=inputTextKey,
  inputModes=inputModes,
  inputFunctions=inputFunctions
}