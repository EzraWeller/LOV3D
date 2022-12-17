bake = require "lib/bake"
camera = require "lib/camera"
arrays = require "lib/arrays"
inputs = require "lib/inputs"
load = require "lib/load"
draw = require "lib/draw"
-- caps to help make state more identifiable when reading
STATE = require "lib/state"

--[[ ARCHITECTURE ]]
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
    
-- Questions: how would lighting and physics fit in here?

--[[ ONCE AT START ]]--
function love.load()
  -- Import entities with level-specific settings
  load.entities(STATE.LEVEL, STATE.ACTORS)

  -- default to "game" controls
  arrays.addUniqueElement(STATE.INPUT_MODES, "game")
end

--[[ RECORD INPUT PRESSES ]]--
-- these don't have specific times?
function love.textinput(t)
  inputs.storeText(t, STATE.INPUT_MODES, STATE.INPUT_TEXT, STATE.INPUT_TEXT_KEY)
end
function love.keypressed(k, s, r)
  inputs.storeKeyboardPress(k, STATE.INPUT_PRESSES, STATE.INPUT_PRESSES_BUFFER)
end
function love.mousepressed(x, y, button)
  inputs.storeMousePress(x, y, button, STATE.INPUT_PRESSES, STATE.INPUT_PRESSES_BUFFER)
end

--[[ EVERY TICK: store held inputs and update state ]]--
function love.update()
  -- record held inputs
  inputs.storeHeld(STATE.INPUTS_HELD, STATE.INPUTS_HELD_BUFFER)

  -- update entities
  camera.update(STATE)
  for i, e in ipairs(STATE.ACTORS) do e.update(e, STATE) end

  -- convert level state into form LOVE2D can render 
  STATE.BAKED_LEVEL = bake.level(STATE.LEVEL, STATE.CAMERA)
end

--[[ EVERY TICK: draw graphics ]]--
function love.draw()
  draw.level(STATE.BAKED_LEVEL)
end