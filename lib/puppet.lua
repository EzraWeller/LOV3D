local puppet = {}

function puppet.processInputs(self)
  if arrays.shareElement(self.entityModes, STATE.INPUT_MODES) then
    local l
    for k, table in pairs(self.inputFunctions) do 
      for l, func in pairs(table) do
        if STATE.INPUTS_HELD[k][l][1] == true then f(self) end
      end
    end
  end
end

return puppet