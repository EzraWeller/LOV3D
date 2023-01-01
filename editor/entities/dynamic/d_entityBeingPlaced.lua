local inputTextKey="EntityPath"
local previousEntityName=nil
local entityId = {}
local entity = {}

-- 
-- needs to go back to being a puppet actually, because it will need a generic response to clicks (placing the entity)

local function update(self)
  -- if entity path has changed, load new entity into the level
  if previousEntityName == nil then

    entityId = spawn.entity({
      type=STATE.SELECTED_ENTITY_TYPE,
      name=STATE.INPUT_TEXT[inputTextKey]
    }, #STATE.LEVEL.layers - 1)
    entity = STATE.LEVEL.layers[entityId.layerIndex][entityId.entityIndex]

  elseif previousEntityName ~= STATE.INPUT_TEXT[inputTextKey] then

    spawn.replaceEntity(entityId, {
      type=STATE.SELECTED_ENTITY_TYPE,
      name=STATE.INPUT_TEXT[inputTextKey]
    }, #STATE.LEVEL.layers - 1)
    entity = STATE.LEVEL.layers[entityId.layerIndex][entityId.entityIndex]

  end

  -- change the position of the entity according to the latest non-relative mouse position
  local latestMousePosition = STATE.MOUSE_POSITIONS[1]
  entity.transform.x = latestMousePosition.x
  entity.transform.y = latestMousePosition.y

  -- make sure the entity is rendered
    -- with some kind of special outline somehow
end

return {
  entityType="dynamic",
  assetType="script",
  update=update,
  inputTextKey=inputTextKey,
}