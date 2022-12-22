local spawn = {}

function spawn.entity(entity, layerIndex, editor)
  local layer = STATE.LEVEL.layers[layerIndex]
  local loadedE = load.entity(entity, editor)
  table.insert(layer.entities, loadedE)
  local id = {layerIndex=layerIndex, entityIndex=#layer.entities}
  if loadedE.entityType == "dynamic" or loadedE.entityType == "puppet" then
    table.insert(STATE.ACTORS, loadedE)
    id.actorIndex = #STATE.ACTORS
  end
  return id
end

function spawn.despawnEntity(layerIndex, entityIndex, actorIndex)
  return true
end

return spawn