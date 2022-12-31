local matrices = {}

function matrices.print(M)
  for i=1,#M do
    local str = ""
    for j=1,#M[i] do
      str = str .. M[i][j] .. " "
    end
    print(str)
  end
end

function matrices.invert(M)
  -- matrix must be square
  if not #M == #M[1] then 
    print("Warning : matrices.inverse : matrix not square")
    return nil
  end

  local i,j,k,c,m

  -- find determinant -- if 0, return nil
    -- TODO -- maybe not needed if we are pretty sure all our matrices will have non-0 determinants?

  -- create augmented matrix [M|I]
  local order = #M
  local A = {}
  for i=1,order do
    A[i] = {}
    for j=1,order do
      A[i][j] = M[i][j]
      local entry = 0
      if i==j then entry = 1 end
      A[i][order + j] = entry
    end
  end
  
  -- apply Gaussian method
  for i=1,order do
    -- Diagonals ([1,1], [2,2], etc.) should be non-0
    if A[i][i] == 0 then
      c = 1
      while (i + c > order and A[i + c][i] == 0) do c = c + 1 end
      if i + c == order then break end -- and do something else???
    end
    for j=1,order do
      if i ~= j then
        local p = A[j][i] / A[i][i]
        for k=1,2 * order do
          A[j][k] = A[j][k] - A[i][k] * p
        end
      end
    end
  end

  -- Make left side identity matrix and right side inverse
  local I = {}

  for i=1,order do
    local d = A[i][i]
    I[i] = {}
    for j=1,2 * order do
      A[i][j] = A[i][j] / d
      if A[i][j] == -0 then A[i][j] = 0 end -- what the hell Lua
      if j > order then
        I[i][j - order] = A[i][j]
      end
    end
  end

  -- return just inverse
  return I
end

--[[

[1,1: 1st row * 1st column, 1,2: 1st row * 2nd column]
[2,1: 2nd row * 1st column, 2,2: 2nd row * 2nd column]
etc.

]]--

function matrices.multiply(Ma, Mb)
  if #Ma ~= #Ma[1] or #Mb ~= #Mb[1] then
    print("Warning : matrices.multiple : matrices must be square")
    return nil
  end

  if #Ma ~= #Mb or #Ma[1] ~= #Mb[1] then
    print("Warning : matrices.multiply : matrices must have the same dimensions")
    return nil
  end

  local R = {}

  local i,j,k
  
  for i=1,#Ma do
    R[i] = {}
    for j=1,#Ma[1] do
      R[i][j] = 0
      for k=1,#Ma do
        R[i][j] = R[i][j] + Ma[i][k] * Mb[k][j]
      end
    end
  end

  return R
end

function matrices.rotationMatrix(axis, degrees)
  if axis == "x" then
    return {
      {1, 0, 0},
      {0, math.cos(math.rad(degrees)), math.sin(math.rad(degrees))},
      {0, -1 * math.sin(math.rad(degrees)), math.cos(math.rad(degrees))}
    }
  elseif axis == "y" then
    return {
      {math.cos(math.rad(degrees)), 0, -1 * math.sin(math.rad(degrees))},
      {0, 1, 0},
      {math.sin(math.rad(degrees)), 0, math.cos(math.rad(degrees))}
    }
  elseif axis == "z" then
    return {
      {math.cos(math.rad(degrees)), math.sin(math.rad(degrees)), 0},
      {-1 * math.sin(math.rad(degrees)), math.cos(math.rad(degrees)), 0},
      {0, 0, 1}
    }
  end
end

return matrices