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

-- TODO walked myself into an obvious problem here: these IDs change when something gets removed...
-- typically, this means giving everything a unique, non-sequential ID, but that's a pain in the ass -- is there another way?
-- well, how hard would that be?
  -- when loading things from the level file, we give everything a random ID
  -- when spawning, we give things a random ID
-- another option could be leaving a blank spot when we remove things, but this seems like it could be a memory leak
  -- the longer a game is open, the more empty spots there will be, the longer all the iterations get. This could end up being really big in a big level with lots of spawning / despawning.
  -- is there a way to leave a blank spot, but then get rid of blank spots on the next update()?
    -- I don't think so, because references to entity IDs may be spread through out other entities in all sorts of ways
  -- still, as a quick fix, we can try leaving blank spots and see when/if it starts causing problems
function spawn.despawnEntity(entityId)
  if STATE.LEVEL.layers[entityId.layerIndex] == nil or
    STATE.LEVEL.layers[entityId.layerIndex].entities[entityId.entityIndex] == nil then
      error.new("spawn", "invalid entity id")
      return false
  end
  STATE.LEVEL.layers[entityId.layerIndex].entities[entityId.entityIndex] = despawned
  if entityId.actorIndex ~= nil then 
    STATE.ACTORS[entityId.actorIndex] = despawned
  end
  return true
end

return spawn