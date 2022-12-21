clicked = require "lib/clicked"
textBox = require "lib/ui" .textBox

local inputTextKey = "ProjectPath"
local previousText = "  "
local selected = false
local lastFlash
local function setLastFlash(time) lastFlash = time end
local barVisible = false
local function setBar(bool) barVisible = bool end

local function onClick(self, STATE, t)
  print('project path onClick')
  selected = true
  STATE.INPUT_MODES = {"text"}
  STATE.INPUT_TEXT_KEY = inputTextKey
end

local function otherClick(self, STATE, t)
  selected = false
end

local function update(self, STATE, t)
  clicked.update(self, STATE, t, "rectangle", onClick, otherClick)
  textBox.update(self, STATE, t, inputTextKey, selected, barVisible, setBar, lastFlash, setLastFlash)
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text=previousText,
    fontSize=12,
    bgColor={1,1,1,1},
    textColor={0,0,0,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  update=update
}