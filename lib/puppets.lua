arrays = require "arrays"

local puppets = {}

function puppets.processInputs(inputs)
  if arrays.shareElement(input_modes, INPUT_MODES) then
    for k, v in pairs(inputs) do
      if arrays.containsElement(k, INPUTS) then v() end
    end
  end
end

return puppets