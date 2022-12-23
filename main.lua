arrays = require "lib/arrays"
bake = require "lib/bake"
camera = require "lib/camera"
cli = require "lib/cli"
clicked = require "lib/clicked"
draw = require "lib/draw"
error = require "lib/error"
inputs = require "lib/inputs"
json = require "lib/json"
load = require "lib/load"
matrices = require "lib/matrices"
obj = require "lib/obj"
project = require "lib/project"
puppet = require "lib/puppet"
sort = require "lib/sort"
spawn = require "lib/spawn"
ui = require "lib/ui"
vectors = require "lib/vectors"

-- caps to help make state more identifiable when reading
STATE = require "lib/state"

-- TODO non-local variables are universal, which means 
  -- we don't need to pass STATE around everywhere, we just have it already
  -- we can even set the current time t in love.update() and then set that in STATE or something, then don't need to pass that around either
  -- we can import all libs in main and then we don't need to import them anywhere else: we can just use them

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

-- swap this to load a different level
-- okay, so because of Lua's virtual file system, we only have access to this directory, so we need 
-- to something janky here. Shell script that "opens" a project by copying it's files into the editor project, 
-- then another that "saves" the project by exporting it back to the original location?
-- Basically, the open script would replace this directory's assets, entities, and levels folders with another directory's.
-- The save script would do the reverse: replace the original directory's folders with this one's.

--[[ ONCE AT START ]]--
function love.load()
  -- record time
  STATE.TIME = love.timer.getTime()

  -- set default editor level to import
  STATE.LEVEL = json.decode(io.input("editor/levels/l_editor.json", "r"):read("a"))

  -- Import entities with level-specific settings
  load.entities("editor")

  -- default to "game" controls
  arrays.addUniqueElement(STATE.INPUT_MODES, "game")
end

--[[ RECORD INPUT PRESSES ]]--
function love.textinput(t)
  inputs.storeText(t)
end
function love.keypressed(k, s, r)
  inputs.storeKeyboardPress(k)
end
function love.mousepressed(x, y, button)
  inputs.storeMousePress(x, y, button)
end

--[[ EVERY TICK: store held inputs and update state ]]--
function love.update()
  -- update time
  STATE.TIME = love.timer.getTime()

  -- record held input like keys being held down
  inputs.storeHeld()

  -- update entities
  camera.update()
  for i, e in ipairs(STATE.ACTORS) do 
    if e ~= nil then e.update(e) end
  end

  -- convert level state into form LOVE2D can render 
  if STATE.LEVEL ~= nil then bake.level() end
end

--[[ EVERY TICK: draw graphics ]]--
function love.draw()
  if STATE.BAKED_LEVEL ~= nil then draw.level() end
end