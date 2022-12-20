local textInputKey = "ProjectPath"

function projectPathOnClick(STATE)
  print('project path on click')
    -- set input modes to only "text" and TEXT_INPUT_KEY to this UI element's textInputKey
    -- remove other input modes
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
  -- get all mouse button 1 clicks with time buffer
  -- for each, see if it's location was within this UI element's boundary
  -- if it was, 
    -- remove that input 
    -- call onClick
  
  -- set this UI element's text to the current TEXT[textInputKey]
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="/",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20},
    onClick=projectPathOnClick
  },
  transform={0, 0},
  update=update
}