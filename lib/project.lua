local project = {}

--[[ spec ]]--
--open project
  -- input path to a folder
  -- check that the folder has this structure:
    -- project folder
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

function project.open(path)
  validateProject(path)
end

function validateProject(path)
  local rootFoldersRequest = io.popen("echo */")
  local rootFolders = rootFoldersRequest:read("*a")
  print('rootFolders', rootFolders)
end

return project