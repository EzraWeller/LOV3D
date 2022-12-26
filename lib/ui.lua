local ui = {textBox={}}

local textBoxBarFlashTime = 0.75
local textBoxBar = "|"

function ui.updateText(self)
  local newText = STATE.INPUT_TEXT[self.inputTextKey] or self.previousText or ""
  if newText ~= nil and newText ~= self.previousText then
    self.asset.text:set(newText)
    self.previousText = newText
    local w,h = self.asset.text:getDimensions()
    self.asset.w = w + self.asset.padding.x
  end
end

function ui.textBox.update(self)
  local newText = STATE.INPUT_TEXT[self.inputTextKey] or ""
  if self.selected then
    -- first time, so toggle bar on
    if self.lastFlash == nil then 
      self.lastFlash =  STATE.TIME 
      self.barVisible = true
    -- should bar toggle
    elseif self.lastFlash <=  STATE.TIME  - textBoxBarFlashTime then
      self.lastFlash =  STATE.TIME 
      if self.barVisible == true then
        self.barVisible = false
      else
        self.barVisible = true
      end
    end
  end
  -- keep text the same visual length without changing STATE data
  if self.selected and self.barVisible == true then 
    newText = newText..textBoxBar 
  else
    newText = newText.." "
  end
  if newText ~= nil and newText ~= self.previousText then
    self.asset.text:set(newText)
    self.previousText = newText
    local w,h = self.asset.text:getDimensions()
    self.asset.w = w + self.asset.padding.x
  end
end

return ui