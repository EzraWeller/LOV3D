local inputs = {}

-- TODO should presses and holds instead be united and each input has things like start and end?

function inputs.storeText(t)
  if arrays.containsElement("text", STATE.INPUT_MODES) then
    if STATE.INPUT_TEXT_KEY~= nil then
      STATE.INPUT_TEXT[STATE.INPUT_TEXT_KEY] = (STATE.INPUT_TEXT[STATE.INPUT_TEXT_KEY] or "") .. t
    end
  end
end

function inputs.storeKeyboardPress(k)
  if STATE.INPUT_PRESSES.keyboard[k] == nil then return end
  if #STATE.INPUT_PRESSES.keyboard[k] == STATE.INPUT_PRESSES_BUFFER then table.remove(STATE.INPUT_PRESSES.keyboard[k]) end
  table.insert(STATE.INPUT_PRESSES.keyboard[k], 1, STATE.TIME)

  if arrays.containsElement("text", STATE.INPUT_MODES) and 
  STATE.INPUT_TEXT[STATE.INPUT_TEXT_KEY] ~= nil and
    k == "backspace" then
      STATE.INPUT_TEXT[STATE.INPUT_TEXT_KEY] = string.sub(STATE.INPUT_TEXT[STATE.INPUT_TEXT_KEY], 1, -2)
  end
end

function inputs.storeMousePress(x, y, b)
  -- deselect text boxes by default (they will reselect themselves if clicked on)
  STATE.INPUT_TEXT_KEY = nil
  if STATE.INPUT_PRESSES.mouse[b] == nil then return end
  if #STATE.INPUT_PRESSES.mouse[b] == STATE.INPUT_PRESSES_BUFFER then table.remove(STATE.INPUT_PRESSES.mouse[b]) end
  table.insert(STATE.INPUT_PRESSES.mouse[b], 1, {x=x, y=y, t=STATE.TIME})
end

function inputs.storeMousePosition(x, y)
  if #STATE.MOUSE_POSITIONS > STATE.INPUT_PRESSES_BUFFER then table.remove(STATE.MOUSE_POSITIONS) end
  table.insert(STATE.MOUSE_POSITIONS, 1, {x=x, y=y})
end

function inputs.storeHeld()
  local k, v
  for k, v in pairs(STATE.INPUTS_HELD.keyboard) do
    -- because "return" is a reserved word AND the name of a key
    local held = false
    if k == "enter" then 
      held = love.keyboard.isDown("return")
    else
      held = love.keyboard.isDown(k)
    end

    if #STATE.INPUTS_HELD.keyboard[k] == STATE.INPUTS_HELD_BUFFER then table.remove(STATE.INPUTS_HELD.keyboard[k]) end
    if held then
      table.insert(STATE.INPUTS_HELD.keyboard[k], 1, true)
    else 
      table.insert(STATE.INPUTS_HELD.keyboard[k], 1, false)
    end
  end
  for k, v in pairs(STATE.INPUTS_HELD.mouse) do
    if #STATE.INPUTS_HELD.mouse[k] == STATE.INPUTS_HELD_BUFFER then table.remove(STATE.INPUTS_HELD.mouse[k]) end
    if love.mouse.isDown(k) then 
      table.insert(STATE.INPUTS_HELD.mouse[k], 1, true)
    else
      table.insert(STATE.INPUTS_HELD.mouse[k], 1, false)
    end
  end
end

return inputs