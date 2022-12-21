local spawn = {}

function spawn.entity(layer, entity, ASSETS, editor)
  local layer = LEVEL[layerIndex]
  local loadedE = load.entity(entity, ASSETS, editor)
  table.insert(layer.entities, loadedE)
  if loadedE.entityType == "dynamic" or loadedE.entityType == "puppet" then
    table.insert(ACTORS, loadedE)
  end
end

return spawn