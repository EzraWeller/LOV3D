local load = {}

function load.entities()
  local j
  for i, layer in ipairs(STATE.LEVEL.layers) do
    for j, e in pairs(layer.entities) do
      local loadedE = load.entity(e, layer.editor)
      layer.entities[j] = loadedE
      if loadedE.entityType == "dynamic" or loadedE.entityType == "puppet" then
        table.insert(STATE.ACTORS, loadedE)
      end
    end
  end
end

function load.entity(entity, editor)
  local loadedE = require((editor or "").."/entities/" .. entity.type .. "/" .. entity.name)
  local copiedE = deep.copy(loadedE)
  override(copiedE, deep.copy(entity))
  if entity.assetType ~= "script" then copiedE.asset = load.entityAsset(copiedE, editor) end
  return copiedE
end

function override(table, o)
  -- TODO validate override keys are valid?
  if o.overrides == nil then return end
  for k, v in pairs(o.overrides) do table[k] = v end
end

function load.entityAsset(e, editor)
  local asset
  if e.assetType == "obj" then
    if STATE.ASSETS[e.asset] == nil then
      STATE.ASSETS[e.asset] = obj.load((editor or "").."assets/" .. e.assetType .. "/" .. e.asset .. ".obj")
    end
    asset = e.asset
  elseif e.assetType == "UI" then
    asset = load.uiAsset(e)
  end
  return asset
end

function load.uiAsset(ui)
  local asset = ui.asset
  love.graphics.setNewFont(asset.fontSize)
  asset.font = love.graphics.getFont()
  asset.text = love.graphics.newText(asset.font, asset.text)
  local w, h = asset.text:getDimensions()
  asset.w = w + asset.padding.x
  asset.h = h + asset.padding.y
  return asset
end

return load