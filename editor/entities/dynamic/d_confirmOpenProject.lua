local function onClick(self)
  -- if INPUT_TEXT[inputTextKey] is not nil,
  -- attempt to open project at that path
  print('confirm open project onClick')
  local path = STATE.INPUT_TEXT[self.inputTextKey]
  print('path', path)
  project.open(path)
  -- delete entities to delete
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