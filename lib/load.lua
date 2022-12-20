obj = require "lib/obj"

local load = {}

function load.entities(LEVEL, ACTORS, ASSETS, editor)
  local j
  for i, layer in ipairs(LEVEL.layers) do
    for j, e in pairs(layer.entities) do
      layer.entities[j] = load.entity(e, ASSETS, editor)
      print('entity asset', layer.entities[j].asset)
      if e.entityType == "dynamic" or e.entityType == "puppet" then
        table.insert(ACTORS, layer.entities[j])
      end
    end
  end
end

function load.entity(entity, ASSETS, editor)
  print('loading entity', entity.name)
  local loadedE = require(editor.."/entities/" .. entity.type .. "/" .. entity.name)
  override(loadedE, entity)
  loadedE.asset = load.entityAsset(loadedE, ASSETS, editor)
  return loadedE
end

function override(table, o)
  -- TODO validate override keys are valid?
  if o.overrides == nil then return end
  for k, v in pairs(o.overrides) do table[k] = v end
end

function load.entityAsset(e, ASSETS, editor)
  local asset
  if e.assetType == "obj" then
    if ASSET[e.asset] == nil then
      ASSET[e.asset] = obj.load(editor.."assets/" .. e.assetType .. "/" .. e.asset .. ".obj")
    end
  elseif e.assetType == "button" then
    -- buttons already have their asset
    asset = e.asset
  end
  return asset
end

return load