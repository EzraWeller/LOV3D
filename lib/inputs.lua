local inputs = {}

function inputs.storeText(t, INPUT_MODES, INPUT_TEXT, INPUT_TEXT_KEY)
  if arrays.containsElement("text", INPUT_MODES) then
    if INPUT_TEXT[INPUT_TEXT_KEY] == nil then INPUT_TEXT[INPUT_TEXT_KEY] = "" end
    INPUT_TEXT[INPUT_TEXT_KEY] = INPUT_TEXT[INPUT_TEXT_KEY] .. t
  end
end

function inputs.storeKeyboardPress(k, t, INPUT_PRESSES, INPUT_PRESSES_BUFFER, INPUT_MODES, INPUT_TEXT, INPUT_TEXT_KEY)
  if INPUT_PRESSES.keyboard[k] == nil then return end
  if #INPUT_PRESSES.keyboard[k] == INPUT_PRESSES_BUFFER then table.remove(INPUT_PRESSES.keyboard[k]) end
  table.insert(INPUT_PRESSES.keyboard[k], 1, t)

  if arrays.containsElement("text", INPUT_MODES) and 
    INPUT_TEXT[INPUT_TEXT_KEY] ~= nil and
    k == "backspace" then
    INPUT_TEXT[INPUT_TEXT_KEY] = string.sub(INPUT_TEXT[INPUT_TEXT_KEY], 1, -2)
  end
end

function inputs.storeMousePress(x, y, b, t, INPUT_PRESSES, INPUT_PRESSES_BUFFER)
  if INPUT_PRESSES.mouse[b] == nil then return end
  if #INPUT_PRESSES.mouse[b] == INPUT_PRESSES_BUFFER then table.remove(INPUT_PRESSES.mouse[b]) end
  table.insert(INPUT_PRESSES.mouse[b], 1, {x=x, y=y, t=t})
end

function inputs.storeHeld(INPUTS_HELD, INPUTS_HELD_BUFFER)
  local k, v
  for k, v in pairs(INPUTS_HELD.keyboard) do
    -- because "return" is a reserved word AND the name of a key
    local held = false
    if k == "enter" then 
      held = love.keyboard.isDown("return")
    else
      held = love.keyboard.isDown(k)
    end

    if #INPUTS_HELD.keyboard[k] == INPUTS_HELD_BUFFER then table.remove(INPUTS_HELD.keyboard[k]) end
    if held then
      table.insert(INPUTS_HELD.keyboard[k], 1, true)
    else 
      table.insert(INPUTS_HELD.keyboard[k], 1, false)
    end
  end
  for k, v in pairs(INPUTS_HELD.mouse) do
    if #INPUTS_HELD.mouse[k] == INPUTS_HELD_BUFFER then table.remove(INPUTS_HELD.mouse[k]) end
    if love.mouse.isDown(k) then 
      table.insert(INPUTS_HELD.mouse[k], 1, true)
    else
      table.insert(INPUTS_HELD.mouse[k], 1, false)
    end
  end
end

return inputs