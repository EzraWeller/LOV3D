local inputTextKey = "EntityPath"
local previousEntityName = nil
local entityId = {}
local entity = {}

-- 
-- needs to go back to being a puppet actually, because it will need a generic response to clicks (placing the entity)

local function update(self)
  local top3dLayerIndex
  local layer
  for i, layer in ipairs(STATE.LEVEL.layers) do
    if layer.type == "3D" then top3dLayerIndex = i end
  end
  -- if entity path has changed, load new entity into the level
  if previousEntityName == nil then

    entityId = spawn.entity({
      type=STATE.SELECTED_ENTITY_TYPE,
      name=STATE.INPUT_TEXT[inputTextKey]
    }, top3dLayerIndex)
    entity = STATE.LEVEL.layers[entityId.layerIndex].entities[entityId.entityIndex]

  elseif previousEntityName ~= STATE.INPUT_TEXT[inputTextKey] then
    print('new entity name')
    spawn.replaceEntity(entityId, {
      type=STATE.SELECTED_ENTITY_TYPE,
      name=STATE.INPUT_TEXT[inputTextKey]
    }, top3dLayerIndex)
    entity = STATE.LEVEL.layers[entityId.layerIndex].entities[entityId.entityIndex]

  end

  -- change the position of the entity according to the latest non-relative mouse position
  local latestMousePosition = STATE.MOUSE_POSITIONS[1]
  if entity.overrides == nil then entity.overrides = {transform={}} end
  entity.overrides.transform = {
    {latestMousePosition.x / 100,0,0,0},
    {0,latestMousePosition.y / 100,0,0},
    {0,0,0,0},
    {0,0,0,1}
  }

  -- make sure the entity is rendered
    -- with some kind of special outline somehow
end

return {
  entityType="dynamic",
  assetType="script",
  update=update,
  inputTextKey=inputTextKey
}