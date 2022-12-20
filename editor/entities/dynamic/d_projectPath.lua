local inputTextKey = "ProjectPath"
local previousText = "/"

function projectPathOnClick(STATE)
  STATE.INPUT_MODES = {"text"}
  STATE.INPUT_TEXT_KEY = inputTextKey
end

function rectangleClicked(rect, click)
  if click.x >= rect.x 
    and click.x <= rect.x + rect.w 
    and click.y >= rect.y 
    and click.y <= rect.y + rect.h then
    return true
  end
  return false
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
  
  local newText = STATE.INPUT_TEXT[inputTextKey]
  if newText ~= nil and newText ~= previousText then
    self.asset.text:set(newText)
    previousText = newText
    local w, h = self.asset.text:getDimensions()
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