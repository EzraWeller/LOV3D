vectors = require "lib/vectors"
obj = require "lib/obj"
matrices = require "lib/matrices"
json = require "lib/json"

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
    -- draws graphics based on state

--[[ STATE ]]--
local levelPath = "levels/l_test.json"
LEVEL = json.decode(io.input(levelPath, "r"):read("a"))
ACTORS = {}
INPUT_MODES = {}

--[[ ONCE AT START ]]--
function love.load()
  print(json.encode(LEVEL))
  loadLevelAssets()
  initState()

  -- workspace
end

function loadLevelAssets()

end

function initState()

end

--[[ EVERY TICK: update state ]]--
function love.update()
  updateActors()
end

function updateActors()

end

--[[ EVERY TICK: draw graphics ]]--
function love.draw()
  drawState()
end

function drawState()

end