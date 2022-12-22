local spawn = {}

function spawn.entity(entity, layerIndex, editor)
  local layer = STATE.LEVEL.layers[layerIndex]
  print('layer', layer, layerIndex, #STATE.LEVEL.layers)
  local loadedE = load.entity(entity, editor)
  table.insert(layer.entities, loadedE)
  if loadedE.entityType == "dynamic" or loadedE.entityType == "puppet" then
    table.insert(STATE.ACTORS, loadedE)
  end
end

return spawn