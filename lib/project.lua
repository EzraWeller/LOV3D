local project = {}

--[[
  Valid project file structure:
  {
    assets={},
    entities={"dynamic"={.lua files},"puppet"={.lua files},"static"={.lua files}},
    levels={.json files}
  }
]]--

function project.open(path)
  local rootFolders = listFolders(path)
  if validateFolders(rootFolders, {"assets", "entities", "levels"}) == false then
    love.event.quit()
    return error.new("project", "invalid project root folder structure")
  end

  local entitiesFolders = listFolders(path.."/entities")
  if validateFolders(entitiesFolders, {"dynamic","puppet","static"}) == false then
    love.event.quit()
    return error.new("project", "invalid project entities folder structure")
  end

  -- write file recording project path
  print("LOV3D opening project at "..path)
  love.filesystem.write("openProject", path)

  -- NOTE: this stuff is linux / mac only for now!
  -- delete our folders and copy the project's
  local copy = io.popen("rm -rf assets entities levels && cp -r "..
    path.."/assets assets && cp -r "..
    path.."/entities entities && cp -r "..
    path.."/levels levels")
  io.close(copy)
  
  project.getFiles()
end

function project.getFiles()
  STATE.PROJECT = {
    entities={
      static=listFiles("entities/static", "lua"),
      dynamic=listFiles("entities/dynamic", "lua"),
      puppet=listFiles("entities/puppet", "lua")
    },
    levels=listFiles("levels", "json")
  }
end

local entityTypes = {"static", "dynamic", "puppet"}

function project.selectNextEntityPath()
  if STATE.PROJECT == nil then return end
  if #STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE] > STATE.SELECTED_ENTITY_INDEX then
    STATE.SELECTED_ENTITY_INDEX = STATE.SELECTED_ENTITY_INDEX + 1
    return
  end
  local typeIndex = arrays.indexOf(STATE.SELECTED_ENTITY_TYPE, entityTypes)
  local newIndex = typeIndex + 1
  if newIndex > 3 then newIndex = newIndex - 3 end
  if #STATE.PROJECT.entities[entityTypes[newIndex]] > 0 then 
    STATE.SELECTED_ENTITY_TYPE = entityTypes[newIndex]
    STATE.SELECTED_ENTITY_INDEX = 1
    return
  end
  newIndex = newIndex + 1
  if newIndex > 3 then newIndex = newIndex - 3 end
  if #STATE.PROJECT.entities[entityTypes[newIndex]] > 0 then 
    STATE.SELECTED_ENTITY_TYPE = entityTypes[newIndex]
    STATE.SELECTED_ENTITY_INDEX = 1
    return
  end
  STATE.SELECTED_ENTITY_INDEX = 1
end

function project.selectePrevEntityPath()
  if STATE.PROJECT == nil then return end
  if STATE.SELECTED_ENTITY_INDEX > 1 then
    STATE.SELECTED_ENTITY_INDEX = STATE.SELECTED_ENTITY_INDEX - 1
    return
  end
  local typeIndex = arrays.indexOf(STATE.SELECTED_ENTITY_TYPE, entityTypes)
  local newIndex = typeIndex - 1
  if newIndex < 1 then newIndex = newIndex + 3 end
  if STATE.PROJECT.entities[entityTypes[newIndex]] ~= nil and #STATE.PROJECT.entities[entityTypes[newIndex]] > 0 then
    STATE.SELECTED_ENTITY_TYPE = entityTypes[newIndex]
    STATE.SELECTED_ENTITY_INDEX = #STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE]
    return
  end
  newIndex = newIndex - 1
  if newIndex < 1 then newIndex = newIndex + 3 end
  if STATE.PROJECT.entities[entityTypes[newIndex]] ~= nil and #STATE.PROJECT.entities[entityTypes[newIndex]] > 0 then 
    STATE.SELECTED_ENTITY_TYPE = entityTypes[newIndex]
    STATE.SELECTED_ENTITY_INDEX = #STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE]
    return
  end
  STATE.SELECTED_ENTITY_INDEX = #STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE]
end

function listFolders(path)
  local foldersRequest = io.popen("echo "..path.."/*/")
  local foldersStr = foldersRequest:read("*a")
  io.close(foldersRequest)
  return splitFolders(foldersStr, " ")
end

function splitFolders(str)
  local t = {}
  for segment in string.gmatch(str, "[^%/]+%/%s") do -- 1+ non-"/".."/".." "
    table.insert(t, string.sub(segment, 1, -3))
  end
  return t
end

-- This could be done with love.filesystem.getDirectoryItems(path) it seems
function listFiles(path, ext)
  local filesRequest = io.popen("echo "..path.."/*."..ext)
  local filesStr = filesRequest:read("*a")
  io.close(filesRequest)
  return splitFiles(filesStr, ext)
end

function splitFiles(str, ext)
  local t = {}
  for segment in string.gmatch(str, "[^%/]+."..ext.."%s") do
    table.insert(t, string.sub(segment, 1, -2))
  end
  return t
end

function validateFolders(folders, requiredFolders)
  for i, f in pairs(requiredFolders) do
    if arrays.containsElement(f, folders) == false then return false end
  end
  return true
end

return project