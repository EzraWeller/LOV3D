local inputTextKey = "LevelPath"

-- should on click load the level into the editor
local function onClick(self)
  -- we want to add the editor level as the top (last) layer to the level
  level.load(STATE.INPUT_TEXT[inputTextKey])
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
    text="Open Level",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  shape="rectangle",
  onClick=onClick,
  otherClick=otherClick,
  inputTextKey=inputTextKey,
  update=update
}