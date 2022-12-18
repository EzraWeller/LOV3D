obj = require "lib/obj"

local load = {}

function load.entities(LEVEL, ACTORS, editor)
  local j
  for i, layer in ipairs(LEVEL.layers) do
    local loadedE
    for j, e in pairs(layer.entities) do
      loadedE = require(editor.."/entities/" .. e.type .. "/" .. e.name)
      override(loadedE, e)
      loadedE.asset = loadEntityAsset(loadedE, editor)
      layer.entities[j] = loadedE
      if e.entityType == "dynamic" or e.entityType == "puppet" then
        table.insert(ACTORS, layer.entities[j])
      end
    end
  end
end

function override(table, o)
  -- TODO validate override keys are valid?
  if o.overrides == nil then return end
  for k, v in pairs(o.overrides) do table[k] = v end
end

function loadEntityAsset(e, editor)
  local asset
  if e.assetType == "obj" then
    asset = obj.load(editor.."assets/" .. e.assetType .. "/" .. e.asset .. ".obj")
  elseif e.assetType == "button" then
    -- buttons are already lua
    asset = e.asset
  end
  return asset
end

return load