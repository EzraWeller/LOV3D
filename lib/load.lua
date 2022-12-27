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
  -- wait, so is what's happening here that the actual data here is being changed?? so we need to make a copy I guess when we load...
  local loadedE = require((editor or "").."/entities/" .. entity.type .. "/" .. entity.name)
  -- make a copy instead of using that file specifically
  local copiedE = deep.copy(loadedE)
  override(copiedE, deep.copy(entity))
  copiedE.asset = load.entityAsset(copiedE, editor)
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
      print('loading obj', json.encode(obj.load((editor or "").."assets/" .. e.assetType .. "/" .. e.asset .. ".obj")))
      STATE.ASSETS[e.asset] = obj.load((editor or "").."assets/" .. e.assetType .. "/" .. e.asset .. ".obj")
    end
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