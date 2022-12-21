clicked = require "lib/clicked"
project = require "lib/project"

local function onClick(self, STATE, t)
  -- if INPUT_TEXT[inputTextKey] is not nil,
  -- attempt to open project at that path
  print('open project onClick')
  local path = STATE.INPUT_TEXT[self.inputTextKey]
  print('path', path)
  if path ~= nil then
    local projectOpen = love.filesystem.getInfo("openProject")
    if projectOpen ~= nil then
      local openProject = love.filesystem.read("openProject")
      -- spawn open project info, confirm open project, and cancel open project
    end
  end
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
    text="Open Project",
    fontSize=12,
    bgColor={0.5,0.5,0.5,1},
    textColor={1,1,1,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  onClick=onClick,
  otherClick=otherClick,
  update=update,
  inputTextKey="ProjectPath"
}