arrays = require "lib/arrays"

local puppets = {}

function puppets.processInputs(inputFunctions, entityModes, activeModes, activeInputs)
  if arrays.shareElement(entityModes, activeModes) then
    for k, f in pairs(inputFunctions) do
      if arrays.containsElement(k, activeInputs) then f() end
    end
  end
end

return puppets