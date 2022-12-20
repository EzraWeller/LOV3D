obj = require "lib/obj"

local load = {}

function load.entities(LEVEL, ACTORS, ASSETS, editor)
  local j
  for i, layer in ipairs(LEVEL.layers) do
    for j, e in pairs(layer.entities) do
      local loadedE = load.entity(e, ASSETS, editor)
      layer.entities[j] = loadedE
      if loadedE.entityType == "dynamic" or loadedE.entityType == "puppet" then
        table.insert(ACTORS, loadedE)
      end
    end
  end
end

function load.entity(entity, ASSETS, editor)
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
  elseif e.assetType == "UI" then
    asset = e.asset
    love.graphics.setNewFont(asset.fontSize)
    asset.font = love.graphics.getFont()
    asset.text = love.graphics.newText(asset.font, asset.text)
    local w, h = asset.text:getDimensions()
    asset.w = w + asset.padding.x
    asset.h = h + asset.padding.y
  end
  return asset
end

return load