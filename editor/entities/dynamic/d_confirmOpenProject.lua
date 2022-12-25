local function onClick(self)
  -- attempt to open project at that path
  project.open(STATE.INPUT_TEXT[self.inputTextKey])
  -- delete entities to delete
  for i, id in ipairs(self.entitiesToDelete) do
    spawn.despawnEntity(id)
  end
end

local function otherClick(self)
end

local function update(self)
  clicked.update(self)
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="Yes",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  shape="rectangle",
  transform={0, 0},
  onClick=onClick,
  otherClick=otherClick,
  update=update,
  inputTextKey="ProjectPath",
  entitiesToDelete={}
}