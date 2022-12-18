json = require "lib/json"

local draw = {}

function draw.level(BAKED_LEVEL)
  local j, k
  for i, layer in ipairs(BAKED_LEVEL) do
    for j, entity in pairs(layer.entities) do
      if layer.type == "3D" then
        love.graphics.setColor(entity.color)
        for k, polygon in pairs(entity.obj) do
          love.graphics.polygon("fill", polygon)
        end
      elseif layer.type == "2D" then
        drawButton(entity.asset, entity.transform)
      end
    end
  end
end

function drawButton(asset, transform)
  love.graphics.setNewFont(asset.fontSize)
  local font = love.graphics.getFont()
  local text = love.graphics.newText(font, asset.text)
  local w, h = text.getDimensions(text)
  love.graphics.setColor(asset.bgColor)
  asset.w = w + asset.padding.x
  if asset.h == nil then asset.h = h + asset.padding.y end
  love.graphics.rectangle("fill", transform[1], transform[2], asset.w, asset.h)
  love.graphics.setColor(asset.textColor)
  love.graphics.draw(text, transform[1] + asset.padding.x/2, transform[2] + asset.padding.y/2)
end

return draw