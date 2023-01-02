local inputTextKey = "EntityPath"

local function onClick(self)
  -- TODO should fail if no level is loaded
  -- spawn a new entity "p_entityBeingPlaced"
  spawn.entity({
    type="dynamic",
    name="d_entityBeingPlaced"
  }, #STATE.LEVEL.layers, "editor")
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