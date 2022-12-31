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
  STATE.CAMERA.viewport.basis = matrices.multiply(
    STATE.CAMERA.viewport.basis, 
    matrices.rotationMatrix("x", STATE.CAMERA.rotationSpeed)
  )
end

function rotateCamDown()
  -- turn camera down
  STATE.CAMERA.viewport.basis = matrices.multiply(
    STATE.CAMERA.viewport.basis, 
    matrices.rotationMatrix("x", STATE.CAMERA.rotationSpeed * -1)
  )
end

function rotateCamLeft()
  -- turn camera left
  STATE.CAMERA.viewport.basis = matrices.multiply(
    STATE.CAMERA.viewport.basis, 
    matrices.rotationMatrix("y", STATE.CAMERA.rotationSpeed)
  )
end

function rotateCamRight()
  -- turn camera right
  STATE.CAMERA.viewport.basis = matrices.multiply(
    STATE.CAMERA.viewport.basis, 
    matrices.rotationMatrix("y", STATE.CAMERA.rotationSpeed * -1)
  )
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