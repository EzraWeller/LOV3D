vectors = require "lib/vectors"
obj = require "lib/obj"
matrices = require "lib/matrices"
json = require "lib/json"
sorts = require "lib/sorts"
bake = require "lib/bake"

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
  -- on start, 
    -- imports the level's assets
    -- creates the initial state
    -- identifies all actors
  -- each tick,
    -- updates state
      -- calls each actor's update function to update state
        -- actors' update functions might:
          -- respond to player input
          -- respond to other objects colliding with them
      -- does any other custom stuff
      -- bakes state into renderable stuff for LOVE2D
    -- draws graphics based on state

--[[ STATE ]]--
LEVEL = json.decode(io.input("levels/l_test.json", "r"):read("a"))
BAKED_LEVEL = {}
DYNAMICS = {}
PUPPETS = {}
INPUT_MODES = {}
ACTIVE_INPUTS = {}
local initialZBasis = {0,0,1}
local initialCamPos = {0,0,0}
local initialDistance = 2000
CAMERA = {
  position=initialCamPos,
  -- camera vector is always the Z basis vector of the viewport!
  distanceToViewport=initialDistance,
  movementSpeed=0.1,
  rotationSpeed=1,
  viewport={
    center=vectors.linearTranslate(initialCamPos, initialZBasis, initialDistance),
    basis={
      {1,0,0},
      {0,1,0},
      initialZBasis -- also describes the camera vector and the normal to the 2d viewport plane!
    },
    size={x=1366, y=768}
  }
}

--[[ ONCE AT START ]]--
function love.load()
  -- Import entities with level-specific settings
  loadEntities()
end

function loadEntities()
  local j
  for i, layer in ipairs(LEVEL.layers) do
    local loadedE
    for j, e in ipairs(layer.entities) do
      loadedE = require("entities/" .. e.type .. "/" .. e.name)
      override(loadedE, e)
      loadedE.asset = loadEntityAsset(loadedE)
      layer.entities[j] = loadedE
      if e.entityType == "dynamic" then
        table.insert(DYNAMICS, layer.entities[j])
      elseif e.entityType == "puppet" then
        table.insert(PUPPETS, layer.entities[j])
      end
    end
  end
end

function override(table, overrider)
  if #overrider.overrides > 0 then
    for k, v in pairs(overrider.overrides) do
      table[k] = overrider.overrides[k]
    end
  end
end

function loadEntityAsset(e)
  local asset
  if e.assetType == "obj" then
    asset = obj.load("assets/" .. e.assetType .. "/" .. e.asset .. ".obj")
  elseif e.assetType == "button" then
    -- buttons are already lua
    asset = e.asset
  end
  return asset
end

--[[ EVERY TICK: update state ]]--
function love.update()
  -- store player inputs
  storeInputs()

  -- update entities
    -- the camera is a special, unique object
  CAMERA = updateCamera(CAMERA)
  updateEntities()

  -- convert level state into form LOVE2D can render 
  BAKED_LEVEL = bake.level(LEVEL, CAMERA)
end

function storeInputs()
  
end

function updateCamera(CAMERA)
  return CAMERA
end

function updateEntities()
  local i, e

  for i, e in ipairs(DYNAMICS) do 
    e = e.update(e, LEVEL) 
  end

  for i, e in ipairs(PUPPETS) do
    e = e.update(e, LEVEL, INPUT_MODES, ACTIVE_INPUTS)
  end
end

--[[ EVERY TICK: draw graphics ]]--
function love.draw()
  -- print('BAKED LEVEL', BAKED_LEVEL)
  drawLevel(BAKED_LEVEL)
end

function drawLevel(BAKED_LEVEL)
  local j, k
  for i, layer in ipairs(BAKED_LEVEL) do
    print('layer', #layer.entities)
    for j, entity in ipairs(layer.entities) do
      print('entity', entity)
      if layer.type == "3D" then
        love.graphics.setColor(entity.color)
        print('color')
        matrices.print(entity.color)
        for k, polygon in ipairs(entity.obj) do
          love.graphics.polygon("fill", polygon)
        end
      elseif layer.type == "2D" then
        -- nothing yet
      end
    end
  end
end