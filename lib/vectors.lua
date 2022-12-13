local vectors = {}

function vectors.make(xval, yval, zval)
  return {xval, yval, zval}
end

function vectors.plus(lhs, rhs)
  return vectors.make(lhs[1] + rhs[1], lhs[2] + rhs[2], lhs[3] + rhs[3])
end

function vectors.minus(lhs, rhs)
  return vectors.make(lhs[1] - rhs[1], lhs[2] - rhs[2], lhs[3] - rhs[3])
end

function vectors.times(lhs, scale)
  return vectors.make(scale * lhs[1], scale * lhs[2], scale * lhs[3])
end

function vectors.dot(lhs, rhs)
  return lhs[1] * rhs[1] + lhs[2] * rhs[2] + lhs[3] * rhs[3]
end

function vectors.toStr(val)
  return "(" .. val[1] .. ", " .. val[2] .. ", " .. val[3] .. ")"
end

function vectors.linePlaneIntersect(lineVector, linePoint, planeNormal, planePoint)
  local denominator = vectors.dot(lineVector, planeNormal)
  if denominator == 0 then
    -- line is either completely in plane (should be impossible) or no intersection
    return nil
  end
  local numerator = vectors.dot(vectors.minus(planePoint, linePoint), planeNormal)
  local scalar = numerator / denominator
  return vectors.plus(linePoint, vectors.times(lineVector, scalar))
end

--[[
Original version of linePlaneIntersect

function vectors.intersectPoint(rayVector, rayPoint, planeNormal, planePoint)
  diff = vectors.minus(rayPoint, planePoint)
  prod1 = vectors.dot(diff, planeNormal)
  prod2 = vectors.dot(rayVector, planeNormal)
  if prod2 == 0 then
    -- line is either completely in plane (should be impossible) or no intersection
    return nil
  end
  prod3 = prod1 / prod2
  return vectors.minus(rayPoint, vectors.times(rayVector, prod3))
end
]]--

function vectors.timesMatrix(vector, matrix)
  if #vector ~= #matrix then
    print("Warning : vectors.timesMatrix : vector length must = matrix row count")
    return nil
  end
  product = {}
  local j
  for i=1,#vector do
    product[i] = 0
    for j=1, #matrix do
      product[i] = product[i] + matrix[j][i] * vector[j]
    end
  end
  return product
end

function vectors.rotateOnAxis(vector, degrees, axis)
  if degrees < -360 or degrees > 360 then
    print('Warning : vectors.rotateOnAxis : Degrees must by >-360, <360')
    return nil
  end
  if axis == "x" then
    return vectors.timesMatrix(
      vector,
      {
        {1, 0, 0},
        {0, math.cos(math.rad(degrees)), math.sin(math.rad(degrees))},
        {0, -1 * math.sin(math.rad(degrees)), math.cos(math.rad(degrees))}
      }
    )
  elseif axis == "y" then
    return vectors.timesMatrix(
      vector,
      {
        {math.cos(math.rad(degrees)), 0, -1 * math.sin(math.rad(degrees))},
        {0, 1, 0},
        {math.sin(math.rad(degrees)), 0, math.cos(math.rad(degrees))}
      }
    )
  elseif axis == "z" then
    return vectors.timesMatrix(
      vector,
      {
        {math.cos(math.rad(degrees)), math.sin(math.rad(degrees)), 0},
        {-1 * math.sin(math.rad(degrees)), math.cos(math.rad(degrees)), 0},
        {0, 0, 1}
      }
    )
  end
  print('Warning : vectors.rotateOnAxis : Axis must by "x", "y", or "z"')
  return nil
end

function vectors.linearTranslate(pointToMove, vector, scalar)
  return vectors.plus(pointToMove, vectors.times(vector, scalar))
end

return vectors