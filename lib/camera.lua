local camera = {}

function moveCamForward()
  -- move "forward": + camera vector times speed
  local CAMERA = STATE.CAMERA
  local change = vectors.times(CAMERA.viewport.basis[3], CAMERA.movementSpeed)
  CAMERA.position = vectors.plus(CAMERA.position, change)
end

function moveCamBackward()
  -- move "backward": - camera vector times speed
  local CAMERA = STATE.CAMERA
  local change = vectors.times(CAMERA.viewport.basis[3], CAMERA.movementSpeed)
  CAMERA.position = vectors.minus(CAMERA.position, change)
end

function rotateCamUp()
  -- turn camera up
  --[[
  local IBasis = matrices.invert(viewport.basis)
  local nb1 = matrices.multiply(xRotation, IBasis)
  local nb2 = matrices.multiply(nb1, viewport.basis)
  viewport.basis = matrices.multiply(viewport.basis, nb2)
  viewport.center = findViewportCenter()
  ]]--
  local CAMERA = STATE.CAMERA
  CAMERA.viewport.basis[1] = vectors.rotateOnAxis(CAMERA.viewport.basis[1], CAMERA.rotationSpeed, "x")
  CAMERA.viewport.basis[2] = vectors.rotateOnAxis(CAMERA.viewport.basis[2], CAMERA.rotationSpeed, "x")
  CAMERA.viewport.basis[3] = vectors.rotateOnAxis(CAMERA.viewport.basis[3], CAMERA.rotationSpeed, "x")
end

function rotateCamDown()
  -- turn camera down
  local CAMERA = STATE.CAMERA
  CAMERA.viewport.basis[1] = vectors.rotateOnAxis(CAMERA.viewport.basis[1], -1 * CAMERA.rotationSpeed, "x")
  CAMERA.viewport.basis[2] = vectors.rotateOnAxis(CAMERA.viewport.basis[2], -1 * CAMERA.rotationSpeed, "x")
  CAMERA.viewport.basis[3] = vectors.rotateOnAxis(CAMERA.viewport.basis[3], -1 * CAMERA.rotationSpeed, "x")
end

function rotateCamLeft()
  -- turn camera left
  local CAMERA = STATE.CAMERA
  CAMERA.viewport.basis[1] = vectors.rotateOnAxis(CAMERA.viewport.basis[1], CAMERA.rotationSpeed, "y")
  CAMERA.viewport.basis[2] = vectors.rotateOnAxis(CAMERA.viewport.basis[2], CAMERA.rotationSpeed, "y")
  CAMERA.viewport.basis[3] = vectors.rotateOnAxis(CAMERA.viewport.basis[3], CAMERA.rotationSpeed, "y")
end

function rotateCamRight()
  -- turn camera right
  local CAMERA = STATE.CAMERA
  CAMERA.viewport.basis[1] = vectors.rotateOnAxis(CAMERA.viewport.basis[1], -1 * CAMERA.rotationSpeed, "y")
  CAMERA.viewport.basis[2] = vectors.rotateOnAxis(CAMERA.viewport.basis[2], -1 * CAMERA.rotationSpeed, "y")
  CAMERA.viewport.basis[3] = vectors.rotateOnAxis(CAMERA.viewport.basis[3], -1 * CAMERA.rotationSpeed, "y")
end

local inputFunctions = {
  keyboard = {
    up=moveCamForward,
    down=moveCamBackward,
    w=rotateCamUp,
    a=rotateCamLeft,
    s=rotateCamDown,
    d=rotateCamRight
  }
}

local entityModes = {"game"}

function camera.update()
  local CAMERA = STATE.CAMERA
  local cameraMoved = false

  if arrays.shareElement(entityModes, STATE.INPUT_MODES) then
    local l
    for k, table in pairs(inputFunctions) do 
      for l, func in pairs(table) do
        if STATE.INPUTS_HELD[k][l][1] == true then
          func(CAMERA)
          cameraMoved = true
        end
      end
    end
  end

  if cameraMoved then 
    CAMERA.viewport.center = findViewportCenter(CAMERA)
  end
  
  return cameraMoved
end

function findViewportCenter()
  local CAMERA = STATE.CAMERA
  return vectors.linearTranslate(
    CAMERA.position,
    CAMERA.viewport.basis[3],
    CAMERA.distanceToViewport
  )
end

return camera