local puppet = {}

function puppet.processInputs(self)
  if arrays.shareElement(self.inputModes, STATE.INPUT_MODES) then
    local l

    -- held inputs
    for k, device in pairs(self.inputFunctions.held) do 
      for l, func in pairs(device) do
        if STATE.INPUTS_HELD[k][l][1] == true then func(self) end
      end
    end

    -- single press inputs
    for k, device in pairs(self.inputFunctions.presses) do 
      for l, func in pairs(device) do
        if #STATE.INPUT_PRESSES[k][l] > 0 then
          for i, t in ipairs(STATE.INPUT_PRESSES[k][l]) do
            if t > STATE.TIME - STATE.INPUT_MS_BUFFER then
              func(self)
            end
            table.remove(STATE.INPUT_PRESSES[k][l], i)
          end
        end
      end
    end
  end
end

return puppet