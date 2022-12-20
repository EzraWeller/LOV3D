arrays = require "lib/arrays"
error = require "lib/error"

local project = {}

--[[ spec ]]--
--open project
  -- input path to a folder
  -- check that the folder has this structure:
    -- project folder
      -- assets
      -- entities
        -- dynamic
        -- puppet
        -- static
      -- levels
  -- return an table like:
    -- { entities = {dynamic = {files names}, puppet = {file names}, static={file names}}, levels = {file names} }
-- elsewhere: create a set of UI things that show this file structure, letting you choose a level
-- open level
  -- project must be loaded
  -- input path to a level in the project
  -- attempt to load the level into the editor
-- save level
  -- 

--[[
  Valid project file structure:
  {
    assets={},
    entities={"dynamic"={.lua files},"puppet"={.lua files},"static"={.lua files}},
    levels={.json files}
  }
]]--

function project.open(path)
  local projectOpen = love.filesystem.getInfo("openProject")
  if projectOpen ~= nil then
    local openProject = love.filesystem.read("openProject")
    local yesNo = cli.yesNo('The project at "'..openProject..'" was last open. Opening will delete unsaved progress. Continue opening?')
    if yesNo == false then 
      print("Open aborted. To save, run...")
      love.event.quit()
      return
    end
  end

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
  io.popen("rm -rf assets entities level && cp -r "..
    path.."/assets assets && cp -r "..
    path.."/entities entities && cp -r "..
    path.."/levels levels")
  io.flush()
  
  return {
    entities={
      dynamic=listLuaFiles("entities/dynamic", "lua"),
      puppet=listLuaFiles("entities/puppet", "lua"),
      static=listLuaFiles("entities/static", "lua")
    },
    levels=listLuaFiles("levels", "json")
  }
end

function listFolders(path)
  local foldersRequest = io.popen("echo "..path.."/*/")
  local foldersStr = foldersRequest:read("*a")
  return splitFolders(foldersStr, " ")
end

function splitFolders(str)
  local t = {}
  for segment in string.gmatch(str, "[^%/]+%/%s") do -- 1+ non-"/".."/".." "
    table.insert(t, string.sub(segment, 1, -3))
  end
  return t
end

function listLuaFiles(path, ext)
  local filesRequest = io.popen("echo "..path.."/*."..ext)
  local filesStr = filesRequest:read("*a")
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