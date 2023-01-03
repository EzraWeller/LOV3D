local inputTextKey = "EntityPath"
local layerIndex = nil

local function onClick(self)
  -- TODO should fail if no level is loaded
  -- spawn a new entity "p_entityBeingPlaced"
  local layer
  for i, layer in ipairs(STATE.LEVEL.layers) do
    if layer.type == "3D" then layerIndex = i end
  end

  local id = spawn.entity({
      type=STATE.SELECTED_ENTITY_TYPE,
      name=STATE.INPUT_TEXT[inputTextKey],
      overrides={
        transform={
          {2,0,0,0},
          {0,2,0,0},
          {0,0,2,0},
          {3,0,30,1}
        },
        color={1,1,1}
    }
  }, layerIndex)
  print('spawned', json.encode(id))
  print('full level', #STATE.LEVEL.layers[id.layerIndex].entities)
  
  --[[
  spawn.entity({
    type="dynamic",
    name="d_entityBeingPlaced"
  }, #STATE.LEVEL.layers, "editor")
  ]]--
end

local function update(self)
  clicked.update(self)
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="Place Entity",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  shape="rectangle",
  onClick=onClick,
  inputTextKey=inputTextKey,
  update=update
}