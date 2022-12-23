local bake = {}

function bake.level()
  local BAKED_LEVEL = {}
  local j
  for i, layer in ipairs(STATE.LEVEL.layers) do
    BAKED_LEVEL[i] = {type=layer.type}
    if layer.type == "3D" then
      local maxDistanceToCam = -1
      local uo = {}
      for j, entity in ipairs(layer.entities) do
        if entity ~= nil then
          local bo = bake.obj(STATE.ASSETS[entity.asset], entity.transform, entity.color)
          if bo.distanceToCam > maxDistanceToCam then maxDistanceToCam = bo.distanceToCam end
          table.insert(uo, bo)
        end
      end
      -- sort
      BAKED_LEVEL[i].entities = sorts.counting(uo, "distanceToCam", maxDistanceToCam)
    elseif layer.type == "2D" then
      BAKED_LEVEL[i].entities = {}
      for j, entity in ipairs(layer.entities) do
        -- right now, UIs are the only 2D asset
        if entity ~= nil then BAKED_LEVEL[i].entities[j] = bake.UI(entity) end
      end
    end
  end
  STATE.BAKED_LEVEL = BAKED_LEVEL
end

function bake.obj(obj, transform, color)
  local bo = {obj={v={}, f=obj.f}, distanceToCam=-1, color=color}
  local vMean = {0,0,0}
  for i, v in ipairs(obj.v) do
    if #transform ~= 0 then 
      bo.obj.v[i] = vectors.timesMatrix(v, transform)
    end
    vSum = {vMean[1] + v[1], vMean[2] + v[2], vMean[3] + v[3]}
  end
  vMean = {vMean[1]/#obj.v, vMean[2] / #obj.v, vMean[3] / #obj.v}
  bo.distanceToCam = distanceBetweenPoints(vMean, STATE.CAMERA.position)
  bo.obj = objTo2d(bo.obj)
  return bo
end

function distanceBetweenPoints(p1, p2)
  return math.sqrt((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2 + (p1[3] - p2[3])^2)
end

function objTo2d(obj)
  local polyhedron = {}
  for i=1,#obj.f do
    local f = obj.f[i]
    local polygon = {}
    local behindCount = 0
    local missingInt = false
    for j=1, #f do
      local vertex3d = obj.v[f[j].v]
      local vertex2d = vertex3dTo2d(vertex3d)
      if vertex2d[1] == nil then
        missingInt = true
      else
        table.insert(polygon, vertex2d[1][1])
        table.insert(polygon, vertex2d[1][2])
      end
      if vertex2d[2] < 0 then behindCount = behindCount + 1 end
    end

    -- render polygon if all of its vertices are in front of the viewport plane and all vertices are in view of the viewport
    -- TODO only require 1+ of the vertices to be in front? But this was creating errors before
    if behindCount == 0 and missingInt == false then table.insert(polyhedron, polygon) end
  end
  return polyhedron
end

function vertex3dTo2d(vertex3d)
  local CAMERA = STATE.CAMERA
  -- check if the vertex is in front of the viewport
  local inFront = vectors.dot(
    CAMERA.viewport.basis[3], 
    vectors.minus(vertex3d, CAMERA.viewport.center)
  ) + CAMERA.distanceToViewport
  -- find vector between vertex3d and camera
  local lineVector = vectors.minus(CAMERA.position, vertex3d)
  -- dot product magic to find intersection between lineVector and viewport plane
  local intersection = vectors.linePlaneIntersect(
    lineVector, 
    vertex3d, 
    CAMERA.viewport.basis[3], 
    CAMERA.viewport.center
  )
  -- if intersection is nil, line is parallel to the plane
  if intersection == nil then return {nil, inFront} end
  -- find intersection x,y with viewport basis as origin
  -- find inverse of the viewport's basis matrix
  -- transform intersection using the inverse
  -- take x, y 
  local I = matrices.invert(CAMERA.viewport.basis)
  local transformed = vectors.timesMatrix(intersection, I)
  return {{transformed[1], transformed[2]}, inFront}
end

function bake.UI(e)
  -- nothing needed
  return e
end

return bake