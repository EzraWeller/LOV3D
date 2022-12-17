arrays = require "lib/arrays"

local puppets = {}

function puppets.processInputs(self, STATE, inputFunctions, entityModes)
  if arrays.shareElement(entityModes, STATE.INPUT_MODES) then
    local l
    for k, table in pairs(inputFunctions) do 
      for l, func in pairs(table) do
        if STATE.INPUTS_HELD[k][l][1] == true then f(self, STATE) end
      end
    end
  end
end

return puppets