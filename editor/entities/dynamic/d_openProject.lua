clicked = require "lib/clicked"
project = require "lib/project"

local inputTextKey = "ProjectPath"
--[[
function onClick(self, STATE, t)
  -- if INPUT_TEXT[inputTextKey] is not nil,
  -- attempt to open project at that path
  local path = STATE.INPUT_TEXT[inputTextKey]
  if path ~= nil then
    project.open(path)
  end
end

function otherClick(self, STATE, t)
end

function update(self, STATE, t)
  clicked.update(self, STATE, t, "rectangle", onClick, otherClick)
end
]]--

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
  update=function() end
}