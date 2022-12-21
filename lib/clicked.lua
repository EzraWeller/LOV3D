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

function clicked.update(self, STATE, t, shape, onClick, otherClick)
  local clickedOn
  for i, c in ipairs(STATE.INPUT_PRESSES.mouse[1]) do
    if c.t > t - STATE.INPUT_MS_BUFFER then
      clickedOn = false
      if shape == "rectangle" then 
        print('shape is rectangle')
        clickedOn = clicked.rectangle({
          x=self.transform[1],
          y=self.transform[2],
          w=self.asset.w,
          h=self.asset.h
        }, c) 
        print('clicked on', clickedOn)
      end
      if clickedOn then
        table.remove(STATE.INPUT_PRESSES.mouse[1], i)
        if onClick ~= nil then 
          print('calling onClick')
          onClick(self, STATE, t) 
        end
      else
        if otherClick ~= nil then otherClick(self, STATE, t) end
      end
    else
      -- This should only fire if the input isn't be used by anything right now
      table.remove(STATE.INPUT_PRESSES.mouse[1], i)
    end
  end
end

return clicked