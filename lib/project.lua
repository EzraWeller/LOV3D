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
  local rootFolders = listFolders(path)
  if validateFolders(rootFolders, {"assets", "entities", "levels"}) == false then
    return error.new("project", "invalid project root folder structure")
  end

  local entitiesFolders = listFolders(path.."/entities")
  if validateFolders(entitiesFolders, {"dynamic","puppet","static"}) == false then
    return error.new("project", "invalid project entities folder structure")
  end
  
  return {
    entities={
      dynamic=listLuaFiles(path.."/entities/dynamic", "lua"),
      puppet=listLuaFiles(path.."/entities/puppet", "lua"),
      static=listLuaFiles(path.."/entities/static", "lua")
    },
    levels=listLuaFiles(path.."/levels", "json")
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