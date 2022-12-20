local inputTextKey = "ProjectPath"
local previousText = "  "

local selected = false
local barFlashTime = 0.75
local lastFlash
local barVisible = false
local bar = "|"

function projectPathOnClick(STATE)
  STATE.INPUT_MODES = {"text"}
  STATE.INPUT_TEXT_KEY = inputTextKey
  print('set input text key', STATE.INPUT_TEXT_KEY)
end

function rectangleClicked(rect, click)
  if click.x >= rect.x 
    and click.x <= rect.x + rect.w 
    and click.y >= rect.y 
    and click.y <= rect.y + rect.h then
    selected = true
  else
    selected = false
  end
  return selected
end

function update(self, STATE, t)
  for i, c in ipairs(STATE.INPUT_PRESSES.mouse[1]) do
    if c.t > t - STATE.INPUT_MS_BUFFER then
      if rectangleClicked({x=self.transform[1],y=self.transform[2],w=self.asset.w,h=self.asset.h}, c) then
        table.remove(STATE.INPUT_PRESSES.mouse[1], i)
        projectPathOnClick(STATE)
      end
    else
      -- This should only fire if the input isn't be used by anything right now
      table.remove(STATE.INPUT_PRESSES.mouse[1], i)
    end
  end
  
  local newText = STATE.INPUT_TEXT[inputTextKey] or ""
  if selected then
    -- first time, so toggle bar on
    if lastFlash == nil then 
      lastFlash = t
      barVisible = true
    -- should bar toggle
    elseif lastFlash <= t - barFlashTime then
      lastFlash = t
      if barVisible == true then
        barVisible = false
      else
        barVisible = true
      end
    end
  end
  -- keep text the same visual length without changing STATE data
  if selected and barVisible == true then 
    newText = newText..bar 
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

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text=previousText,
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=projectPathOnClick
  },
  transform={0, 0},
  update=update
}