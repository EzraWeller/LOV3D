local ui = {textBox={}}

local textBoxBarFlashTime = 0.75
local textBoxBar = "|"

function ui.textBox.update(
  self, 
  STATE, 
  t, 
  inputTextKey, 
  selected, 
  barVisible, 
  setBar, 
  lastFlash, 
  setLastFlash
)
  local newText = STATE.INPUT_TEXT[inputTextKey] or ""
  if selected then
    -- first time, so toggle bar on
    if lastFlash == nil then 
      setLastFlash(t)
      setBar(true)
    -- should bar toggle
    elseif lastFlash <= t - textBoxBarFlashTime then
      setLastFlash(t)
      if barVisible == true then
        setBar(false)
      else
        setBar(true)
      end
    end
  end
  -- keep text the same visual length without changing STATE data
  if selected and barVisible == true then 
    newText = newText..textBoxBar 
  else
    newText = newText.." "
  end
  if newText ~= nil and newText ~= previousText then
    self.asset.text:set(newText)
    previousText = newText
    local w,h = self.asset.text:getDimensions()
    self.asset.w = w + self.asset.padding.x
  end
end

return ui