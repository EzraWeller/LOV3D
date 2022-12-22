local function onClick(self)
  self.selected = true
  STATE.INPUT_MODES = {"text"}
  STATE.INPUT_TEXT_KEY = self.inputTextKey
end

local function otherClick(self)
  selected = false
end

local function update(self)
  clicked.update(self)
  ui.textBox.update(self)
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="  ",
    fontSize=12,
    bgColor={1,1,1,1},
    textColor={0,0,0,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  update=update,
  onClick=onClick,
  otherClick=otherClick,
  shape="rectangle",
  inputTextKey = "ProjectPath",
  previousText = nil,
  selected = false,
  lastFlash = nil,
  barVisible = false
}