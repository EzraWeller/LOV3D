local ui = {textBox={}}

local textBoxBarFlashTime = 0.75
local textBoxBar = "|"

function ui.textBox.update(self, STATE, t)
  local newText = STATE.INPUT_TEXT[inputTextKey] or ""
  if self.selected then
    -- first time, so toggle bar on
    if self.lastFlash == nil then 
      self.lastFlash = t
      self.barVisible = true
    -- should bar toggle
    elseif self.lastFlash <= t - textBoxBarFlashTime then
      self.lastFlash = t
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