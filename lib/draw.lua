local draw = {}

function draw.level()
  local j, k
  for i, layer in ipairs(STATE.BAKED_LEVEL) do
    for j, entity in pairs(layer.entities) do
      if layer.type == "3D" then
        love.graphics.setColor(entity.color)
        for k, polygon in pairs(entity.obj) do
          love.graphics.polygon("fill", polygon)
        end
      elseif layer.type == "2D" then
        drawUI(entity.asset, entity.transform)
      end
    end
  end
end

function drawUI(asset, transform)
  love.graphics.setColor(asset.bgColor)
  love.graphics.rectangle("fill", transform[1], transform[2], asset.w, asset.h)
  love.graphics.setColor(asset.textColor)
  love.graphics.draw(asset.text, transform[1] + asset.padding.x/2, transform[2] + asset.padding.y/2)
end

return draw