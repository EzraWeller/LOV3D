vectors = require "lib/vectors"
obj = require "lib/obj"
matrices = require "lib/matrices"

--[[ GLOBALS ]]--

-- camera setup
CAMERA = {
  position={0,0,0},
  -- camera vector is always the 3rd basis vector of the viewport!
  distanceToViewport=2000,
  movementSpeed=0.1,
  rotationSpeed=1
}

-- viewport setup
initialZBasis={0,0,1}
VIEWPORT={
  center=vectors.linearTranslate(CAMERA.position, initialZBasis, CAMERA.distanceToViewport),
  basis={
    {1,0,0},
    {0,1,0},
    initialZBasis -- also describes the camera vector and the normal to the 2d viewport plane!
  },
  size={x=1366, y=768}
}

ASSETS = "/assets"

-- default / current layer info
--[[
Layouts will render in order (last layer in list is on highest layer).
The main idea here is to able to layer 2D layers with 3D: I imagine a standard might be {background, objects, UI}
]]--
LAYERS = {require("layers/test3d"), require("layers/testGUI")}
LOADED_ASSETS = {}
STATE = {}
CLICKABLES = {buttons={}}

ACTIVE_CONTROLS = {textInput=false, camera=true}

INPUT_TEXT = {}

GUI = {
  buttons={
    OpenLevelSubmit={
      text="Open Level",
      fontSize=12,
      bgColor={0,0,0,1},
      textColor={1,1,1,1},
      pos={x=0, y=0},
      padding={x=20, y=20},
      callback=function()
        print('Open Level Submit callback')
      end
    },
    OpenLevelPath={
      text="/",
      fontSize=12,
      bgColor={0,0,0,1},
      textColor={1,1,1,1},
      pos={x=100, y=0},
      padding={x=20, y=20},
      callback=function() OpenLevelPathCallback() end
    },
  }
}

INITIAL_GUI = {buttons={"OpenLevelSubmit", "OpenLevelPath"}}

function OpenLevelPathCallback()
  print('open layer path callback')
  ACTIVE_CONTROLS.textInput = true
  ACTIVE_CONTROLS.camera = false
  inputTextKey = "OpenLevelPath"
end

--[[
  This function gets called only once, when the game is started,
  and is usually where you would load resources, initialize 
  variables and set specific settings. All those things can be 
  done anywhere else as well, but doing them here means that they 
  are done once only, saving a lot of system resources.
]]--
function love.load()
  -- size the screen
  local success = love.window.updateMode(VIEWPORT.size.x, VIEWPORT.size.y, {resizable=true})

  -- set up textinput
  inputTextKey = nil

  -- create background
  background = love.graphics.newCanvas()
  background:renderTo(function()
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle("fill", 0, 0, VIEWPORT.size.x, VIEWPORT.size.y)
  end)

  rerenderGui = true

  -- load default layer
  loadAssets()
  bakeLayers()

  -- set up camera rotations
  local degrees = CAMERA.rotationSpeed
  xRotation = {
    {1, 0, 0},
    {0, math.cos(math.rad(degrees)), math.sin(math.rad(degrees))},
    {0, -1 * math.sin(math.rad(degrees)), math.cos(math.rad(degrees))}
  }

  -- workspace
end

function renderGui(gui)
  gui:renderTo(function()
    for i=1,#guiState.buttons do
      makeButton(guiState.buttons[i])
    end
  end)
  rerenderGui = false
end

function makeButton(buttonName)
  local params = GUI.buttons[buttonName]
  love.graphics.setNewFont(params.fontSize)
  local font = love.graphics.getFont()
  local text = love.graphics.newText(font, params.text)
  if INPUT_TEXT[buttonName] ~= nil then text:set(INPUT_TEXT[buttonName]) end
  local w, h = text.getDimensions(text)
  love.graphics.setColor(params.bgColor)
  GUI.buttons[buttonName].w = w + params.padding.x
  if GUI.buttons[buttonName].h == nil then GUI.buttons[buttonName].h = h + params.padding.y end
  love.graphics.rectangle("fill", params.pos.x, params.pos.y, GUI.buttons[buttonName].w, GUI.buttons[buttonName].h)
  love.graphics.setColor(params.textColor)
  love.graphics.draw(text, params.pos.x + params.padding.x/2, params.pos.y + params.padding.y/2)
end

function resetLoadedAssets()
  LOADED_ASSETS = {objs={}, buttons={}}
end

function resetBakedLayers()
  STATE = {}
end

--[[
  How we should handle controls and updating / drawing
    - in update
      - check if state indicates change (i.e. key is down)
      - if it is, make change
        - i.e. if "up" is down, change the camera position by X (speed = distance / tick)
]]--

-- TODO 

-- Framerate: would the way to do a framerate cap be to check in update if it has 
-- been at least e.g. 1/60 of a second, and if not, skip?

function love.textinput(t)
  if ACTIVE_CONTROLS.textInput == true then
    if INPUT_TEXT[inputTextKey] == nil then INPUT_TEXT[inputTextKey] = "" end
    INPUT_TEXT[inputTextKey] = INPUT_TEXT[inputTextKey] .. t
    rerenderGui = true
  end
end

function love.keypressed(k, s, r)
  if ACTIVE_CONTROLS.textInput == true then
    if k == "backspace" then
      if INPUT_TEXT[inputTextKey] ~= nil then
        INPUT_TEXT[inputTextKey] = string.sub(INPUT_TEXT[inputTextKey], 1, -2)
        rerenderGui = true
      end
    end
  end
end

function love.mousepressed(x, y, button)
  -- default to camera -- if clicked on a text field, this will get swapped by button callbacks
  ACTIVE_CONTROLS.textInput = false
  ACTIVE_CONTROLS.camera = true

  if button == 1 then
    local i
    -- guiState is going away. Instead, when baking layers, somehow store a list of references to the clickable items, then check those here
    --[[
    for i=1,#guiState.buttons do
      local params = GUI.buttons[guiState.buttons[i
      if pointInsideRectangle(x, y, params.pos.x, params.pos.y, params.w, params.h) then
        params.callback()
      end
    end
    ]]--

    local b
    for i=1,#CLICKABLES.buttons do
      b = CLICKABLES.buttons[i]
      if pointInsideRectangle(x, y, b.pos.x, b.pos.y, b.w, b.h) then
        b.onClick()
      end
    end
  end
end

function pointInsideRectangle(px, py, rx, ry, rw, rh)
  if px > rx and px > ry and px < rx + rw and py < ry + rh then
    return true
  end
  return false
end

--[[
  This function is called continuously and will probably be where 
  most of your math is done. 'dt' stands for "delta time" and is 
  the amount of seconds since the last time this function was called 
  (which is usually a small value like 0.025714).
]]--
function love.update(dt)
  if ACTIVE_CONTROLS.camera == true then
    local cameraMoved = moveCamera()
    if cameraMoved then
      -- print('camera moved', vectors.toStr(CAMERA.position))
      bakeLayers()
    end
  end
end

--[[
  love.draw is where all the drawing happens (if that wasn't obvious 
  enough already) and if you call any of the love.graphics.draw outside 
  of this function then it's not going to have any effect. This 
  function is also called continuously so keep in mind that if you 
  change the font/color/mode/etc at the end of the function then 
  it will have an effect on things at the beginning of the function.
]]--
function love.draw()
  -- draw background
  love.graphics.draw(background)

  -- render the scene
  renderLayers()

  -- draw menus
  --[[
  if rerenderGui == true then 
    love.graphics.setCanvas(gui)
    love.graphics.clear()
    love.graphics.setCanvas()
    renderGui(gui) 
  end
  love.graphics.draw(gui)
  ]]--
  
  -- workspace
end

--[[
  How to do 3d in 2d here:
    - neither the game designer nor the viewer should ever deal directly with 2d locations
      - game designer places something in 3d space
      - viewer sees it in 3d space
      - game engine translates to 2d
    - draw an OBJ file in 3d space in relation to a camera
      - X function to convert a flat polygon in 3d (list of vertices) to a love.graphics.polygon (list of vertices)
        - need something defining location and vector of the polygon
      - X define a third dimension
      - X define position of the camera in 3d
      - import OBJ file (probably will only support vertices, faces, and normals)
      - perform and needed location, rotation, and  scale transformation on OBJ's vertices
      - iterate over OBJ's faces to create a list of 2d polygons (i.e. list of sets of vertices) to render
      - render the polygons

  -- Obviously in the future this system would need like a scene editor interface and such
        -- maybe you could do it by putting stuff in blender and just manually looking at the position?
]]--

function findViewportCenter()
  return vectors.linearTranslate(
    CAMERA.position,
    VIEWPORT.basis[3],
    CAMERA.distanceToViewport
  )
end

function loadAssets()
  resetLoadedAssets()
  local j
  for i=1,#LAYERS do
    local layer = LAYERS[i]
    if layer.type == "3D" then
      for j=1,#layer.objFiles do
        local fileName = layer.objFiles[j]
        if LOADED_ASSETS.objs[fileName] == nil then
          LOADED_ASSETS.objs[fileName] = obj.load(ASSETS .. "/obj/" .. fileName .. ".obj")
        end
      end
    elseif layer.type == "2D" then
      for j=1,#layer.buttons do 
        local buttonName = layer.buttons[j]
        if LOADED_ASSETS.buttons[buttonName] == nil then
          LOADED_ASSETS.buttons[buttonName] = require("assets/buttons/" .. buttonName)
        end
      end
    end
  end
end

-- ASSETS are raw files that will be used by the game to construct game objects: .obj, .wav, .png, etc.
-- ENTITIES are lua structures that can be interpreted and used by the game
  -- STATIC entities never change their state after initial bake
  -- DYNAMIC entities have an .update(self) function 
    -- PUPPET entities are dynamic entities that have 
      -- a set of controls -- player commands the character responds to
      -- at least one INPUT_MODE, which tell the engine when that entity should listen to inputs (e.g. UI elements only take input when in UI input mode)
-- LAYERS are sets of ENTITIES
-- LEVELS are sets of LAYERS, in the order they should rendered on top of each other (bg then forground then UI, for example)
-- the ENGINE is the core program, and it
  -- loads LEVELS
  -- keeps a STATE
  -- etc.

-- TODO rendering system that can deal with ACTORS
  -- actors are objects that have their own custom scripts that can change their state every tick
  -- this "baking" system exists to get objects in the form usable by the engine -- it should only happen once
  -- that means actors need to change their post-baked state
  -- BAKED_LAYERS --> STATE
  -- in love.update, cycle through STATE for actors and call their update functions which update STATE
    -- 
  -- in love.draw, draw STATE

function bakeLayers()
  resetBakedLayers()
  local j
  for i=1,#LAYERS do
    local layer = LAYERS[i]
    STATE[i] = {type=layer.type}
    if layer.type == "3D" then
      local maxDistanceToCam = -1
      local unsortedObjs = {}
      for j=1,#layer.objFiles do
        local obj = LOADED_ASSETS.objs[layer.objFiles[j]]
        local matrix = layer.objTransforms[j]
        local bakedObj = bakeObj(obj, matrix, layer.objColors[j])
        if bakedObj.distanceToCam > maxDistanceToCam then maxDistanceToCam = bakedObj.distanceToCam end
        table.insert(unsortedObjs, bakedObj)
      end
      -- sort
      STATE[i].obj = countingSortTableBy(unsortedObjs, "distanceToCam", maxDistanceToCam)
    elseif layer.type == "2D" then -- for 2D layers
      STATE[i].buttons = {}
      for j=1,#layer.buttons do
        -- add pos to buttons and add to baked layers
        local bb = bakeButton(layer.buttons[j], layer.buttonPositions[j])
        STATE[i].buttons[j] = bb
        -- also add to clickables
        table.insert(CLICKABLES.buttons, bb)
      end
    end
  end
end

function bakeObj(obj, matrix, color)
  -- if empty matrix, don't transform
  if #matrix == 0 then return obj end
  -- apply transformation matrix to obj's vertices
    -- apply full 4x4 transform to each vertex
  local bo = {obj={v={}, f=obj.f}, distanceToCam=-1, color=color}
  local distance = -1
  for i=1,#obj.v do
    bo.obj.v[i] = vectors.timesMatrix(obj.v[i], matrix)
    -- re: below. bad long term to be calculating this for every vertex every tick?
      -- if we had a "center point" for each object, we could just calc once per object on that
    distance = distanceBetweenPoints(bo.obj.v[i], CAMERA.position)
    if bo.distanceToCam == -1 or distance < bo.distanceToCam then
      bo.distanceToCam = distance
    end
  end
  -- TODO when / if we need normals: apply just rotation (not scale or translation) to normals
  -- transform to 2d
  bo.obj = polyhedron3dTo2d(bo.obj)
  return bo
end

function bakeButton(name, pos)
  local button = LOADED_ASSETS.buttons[name]
  love.graphics.setNewFont(button.fontSize)
  local font = love.graphics.getFont()
  local text = love.graphics.newText(font, INPUT_TEXT[name] or button.text)
  local w, h = text.getDimensions(text)
  return {
    text=text,
    font=font,
    bgColor=button.bgColor,
    textColor=button.textColor,
    padding=button.padding,
    w=w + button.padding.x,
    h=h + button.padding.y,
    onClick=button.onClick,
    pos=pos
  }
end

function countingSortTableBy(table, key, maxValue)
  local count = {}
  for i=1,maxValue + 1 do count[i] = 0 end

  local output = {}
  local value = 0

  -- histogram of key-values in table
  for i=1,#table do 
    value = math.floor(table[i][key]) + 1
    count[value] = count[value] + 1
  end

  -- prefix sum to convert histogram into order
  for i=1,#count do 
    if i ~= 1 then
      count[i] = count[i] + count[i - 1]
    end
  end

  -- order table items in output
  for i=#table, 1, -1 do 
    value = math.floor(table[i][key]) + 1
    output[count[value]] = table[i]
  end

  return output
end

function renderLayers()
  local j
  for i=1,#STATE do
    local bl = STATE[i]
    if bl.type == "3D" then
      for j=#bl.obj, 1, -1 do
        local bo = bl.obj[j]
        love.graphics.setColor(bo.color)
        for j=1, #bo.obj do
          local polygon = bo.obj[j]
          love.graphics.polygon("fill", polygon)
        end
      end
    elseif bl.type == "2D" then
      if rerenderGui == true then
        for j=1,#bl.buttons do
          renderButton(bl.buttons[j])
        end
      end
    end
  end
end

function renderButton(button)
  love.graphics.setColor(button.bgColor)
  love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.w, button.h)
  love.graphics.setColor(button.textColor)
  love.graphics.draw(button.text, button.pos.x + button.padding.x/2, button.pos.y + button.padding.y/2)
end

function moveCamera()
  local cameraMoved = false
  local cameraVectorMoved = false
  if love.keyboard.isDown("up") then
    -- move "forward": + camera vector times speed
    local change = vectors.times(VIEWPORT.basis[3], CAMERA.movementSpeed)
    CAMERA.position = vectors.plus(CAMERA.position, change)
    cameraMoved = true
  end
  if love.keyboard.isDown("down") then
    -- move "backward": - camera vector times speed
    local change = vectors.times(VIEWPORT.basis[3], CAMERA.movementSpeed)
    CAMERA.position = vectors.minus(CAMERA.position, change)
    cameraMoved = true
  end
  if love.keyboard.isDown("w") then
    -- turn camera up
    local IBasis = matrices.invert(VIEWPORT.basis)
    local nb1 = matrices.multiply(xRotation, IBasis)
    local nb2 = matrices.multiply(nb1, VIEWPORT.basis)
    VIEWPORT.basis = matrices.multiply(VIEWPORT.basis, nb2)
    VIEWPORT.center = findViewportCenter()
    --[[
    VIEWPORT.basis[1] = vectors.rotateOnAxis(VIEWPORT.basis[1], CAMERA.rotationSpeed, "x")
    VIEWPORT.basis[2] = vectors.rotateOnAxis(VIEWPORT.basis[2], CAMERA.rotationSpeed, "x")
    VIEWPORT.basis[3] = vectors.rotateOnAxis(VIEWPORT.basis[3], CAMERA.rotationSpeed, "x")
    ]]--
    cameraVectorMoved = true
  end
  if love.keyboard.isDown("s") then
    -- turn camera down
    VIEWPORT.basis[1] = vectors.rotateOnAxis(VIEWPORT.basis[1], -1 * CAMERA.rotationSpeed, "x")
    VIEWPORT.basis[2] = vectors.rotateOnAxis(VIEWPORT.basis[2], -1 * CAMERA.rotationSpeed, "x")
    VIEWPORT.basis[3] = vectors.rotateOnAxis(VIEWPORT.basis[3], -1 * CAMERA.rotationSpeed, "x")
    cameraVectorMoved = true
  end
  if love.keyboard.isDown("a") then
    -- turn camera left
    -- when rotating around Y, rotate X and Z basis around Y
    VIEWPORT.basis[1] = vectors.rotateOnAxis(VIEWPORT.basis[1], CAMERA.rotationSpeed, "y")
    VIEWPORT.basis[2] = vectors.rotateOnAxis(VIEWPORT.basis[2], CAMERA.rotationSpeed, "y")
    VIEWPORT.basis[3] = vectors.rotateOnAxis(VIEWPORT.basis[3], CAMERA.rotationSpeed, "y")
    cameraVectorMoved = true
  end
  if love.keyboard.isDown("d") then
    -- turn camera right
    VIEWPORT.basis[1] = vectors.rotateOnAxis(VIEWPORT.basis[1], -1 * CAMERA.rotationSpeed, "y")
    VIEWPORT.basis[2] = vectors.rotateOnAxis(VIEWPORT.basis[2], -1 * CAMERA.rotationSpeed, "y")
    VIEWPORT.basis[3] = vectors.rotateOnAxis(VIEWPORT.basis[3], -1 * CAMERA.rotationSpeed, "y")
    cameraVectorMoved = true
  end
  if cameraMoved or cameraVectorMoved then 
    VIEWPORT.center = findViewportCenter()
  end
  return cameraMoved or cameraVectorMoved
end

function distanceBetweenPoints(p1, p2)
  return math.sqrt((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2 + (p1[3] - p2[3])^2)
end

function polyhedron3dTo2d(obj)
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

    -- render polygon if all of its vertices on in front of the viewport plane 
    -- and all vertices are in view of the viewport
    -- TODO: only require 1+ of the vertices to be in front? This was creating errors before
    if behindCount == 0 and missingInt == false then table.insert(polyhedron, polygon) end
  end
  return polyhedron
end

function vertex3dTo2d(vertex3d)
  -- check if the vertex is in front of the viewport.
  local inFront = vectors.dot(VIEWPORT.basis[3], vectors.minus(vertex3d, VIEWPORT.center)) 
    + CAMERA.distanceToViewport
  -- find vector between vertex3d and camera
  local lineVector = vectors.minus(CAMERA.position, vertex3d)
  -- dot product magic to find intersection between lineVector and viewport plane
  local intersection = vectors.linePlaneIntersect(
    lineVector, 
    vertex3d, 
    VIEWPORT.basis[3], 
    VIEWPORT.center
  )
  -- if intersection is nil, line is parallel to the plane
  if intersection == nil then return {nil, inFront} end
  -- find intersection x,y with viewport basis as origin
  -- find inverse of the viewport's basis matrix
  -- transform intersection using the inverse
  -- take x, y 
  local I = matrices.invert(VIEWPORT.basis)
  local transformed = vectors.timesMatrix(intersection, I)
  return {{transformed[1], transformed[2]}, inFront}
end