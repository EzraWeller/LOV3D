local function addEntitiesToDelete(addeeIds, entitiesToDelete)
  local addee
  for i, id in ipairs(addeeIds) do
    addee = STATE.LEVEL.layers[id.layerIndex].entities[id.entityIndex]
    addee.entitiesToDelete = entitiesToDelete
  end
end

local function onClick(self)
  local path = STATE.INPUT_TEXT[self.inputTextKey]
  if path ~= nil then
    local projectOpen = love.filesystem.getInfo("openProject")
    if projectOpen ~= nil then
      local openProject = love.filesystem.read("openProject")
      -- spawn open project info, confirm open project, and cancel open project
      local w, h = love.graphics.getDimensions()
      local openProjectInfoId = spawn.entity({
        type="static",
        name="s_openProjectInfo",
        overrides={
          asset={
            text='Open project at "'..path..'"? \nProject at "'..openProject..'" \nwas/is open and unsaved progress will be lost.',
            fontSize=12,
            bgColor={1,1,1,1},
            textColor={0,0,0,1},
            padding={x=20, y=20}
          },
          transform={w/4, h/4}
        }
      }, #STATE.LEVEL.layers, "editor")
      print('spawned info')
      local confirmOpenProjectId = spawn.entity({
        type="dynamic",
        name="d_confirmOpenProject",
        overrides={transform={w/4, h/4 + 70}}
      }, #STATE.LEVEL.layers, "editor")
      print('spawned confirm')
      local cancelOpenProjectId = spawn.entity({
        type="dynamic",
        name="d_cancelOpenProject",
        overrides={transform={w/4 + 100, h/4 + 70}}
      }, #STATE.LEVEL.layers, "editor")
      print('spawned cancel')
      addEntitiesToDelete(
        {confirmOpenProjectId, cancelOpenProjectId},
        {openProjectInfoId, confirmOpenProjectId, cancelOpenProjectId}
      )
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