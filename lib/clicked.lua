local clicked = {}

function clicked.rectangle(rect, click)
  if click.x >= rect.x 
    and click.x <= rect.x + rect.w 
    and click.y >= rect.y 
    and click.y <= rect.y + rect.h then
    return true
  end
  return false
end

function clicked.update(self)
  local clickedOn
  for i, c in ipairs(STATE.INPUT_PRESSES.mouse[1]) do
    if c.t > STATE.TIME - STATE.INPUT_MS_BUFFER then
      clickedOn = false
      if self.shape == "rectangle" then
        clickedOn = clicked.rectangle({
          x=self.transform[1],
          y=self.transform[2],
          w=self.asset.w,
          h=self.asset.h
        }, c)
      end
      if clickedOn then
        table.remove(STATE.INPUT_PRESSES.mouse[1], i)
        if self.onClick ~= nil then
          self.onClick(self) 
        end
      else
        if self.otherClick ~= nil then self.otherClick(self) end
      end
    else
      -- This should only fire if the input isn't be used by anything right now
      table.remove(STATE.INPUT_PRESSES.mouse[1], i)
    end
  end
end

return clicked