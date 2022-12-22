local function onClick(self)
  local path = STATE.INPUT_TEXT[self.inputTextKey]
  if path ~= nil then
    local projectOpen = love.filesystem.getInfo("openProject")
    if projectOpen ~= nil then
      local openProject = love.filesystem.read("openProject")
      -- spawn open project info, confirm open project, and cancel open project
      local w, h = love.graphics.getDimensions()
      spawn.entity({
        type="static",
        name="s_openProjectInfo",
        overrides={
          asset={
            text='Open project at "'..path..'" ? Previously, "'..openProject..'" was open and unsaved progress will be lost.',
            fontSize=12,
            bgColor={0.5,0.5,0.5,1},
            textColor={1,1,1,1},
            padding={x=20, y=20}
          },
          transform={w/2, h/2}
        }
      }, #STATE.LEVEL.layers, "editor")
    end
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
  shape="rectangle",
  inputTextKey="ProjectPath"
}