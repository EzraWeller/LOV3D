clicked = require "lib/clicked"

local function onClick(self, STATE, t)
  print('cancel open project onClick')
  -- despawn self, confirmOpenProject and openProjectInfo
  -- how do we get references to the correct entities?
    -- somehow pass in a list of of the layer index and entity index of the to-be-despawned entities?
      -- after loading, set entitiesToDelete
end

local function otherClick(self, STATE, t)
end

local function update(self, STATE, t)
  clicked.update(self, STATE, t)
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="Cancel",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  onClick=onClick,
  otherClick=otherClick,
  update=update,
  entitiesToDelete={}
}