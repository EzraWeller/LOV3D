json = require "lib/json"

local initialCamZBasis = {0,0,1}
local initialCamPos = {-10,-10,0}
local initialCamDistance = 2000

local STATE = {
  LEVEL = json.decode(io.input("levels/l_test.json", "r"):read("a")),
  BAKED_LEVEL = {},
  ACTORS = {},
  INPUT_MODES = {},
  INPUTS_HELD = {
    keyboard = {
      a={},b={},c={},d={},e={},f={},g={},h={},j={},k={},
      l={},m={},n={},o={},p={},q={},r={},s={},t={},u={},
      v={},w={},x={},y={},z={},
      up={},down={},left={},right={},
      space={},escape={},enter={}
    },
    mouse = {{},{}}
  },
  INPUTS_HELD_BUFFER = 100,
  INPUT_PRESSES = {
    keyboard = {
      a={},b={},c={},d={},e={},f={},g={},h={},j={},k={},
      l={},m={},n={},o={},p={},q={},r={},s={},t={},u={},
      v={},w={},x={},y={},z={},
      up={},down={},left={},right={},
      space={},escape={},enter={}
    },
    mouse = {{},{}}
  },
  INPUT_PRESSES_BUFFER = 100,
  INPUT_TEXT = {},
  INPUT_TEXT_KEY = nil,
  CAMERA = {
    position=initialCamPos,
    -- camera vector is always the Z basis vector of the viewport!
    distanceToViewport=initialCamDistance,
    movementSpeed=0.1,
    rotationSpeed=1,
    viewport={
      center=vectors.linearTranslate(initialCamPos, initialCamZBasis, initialCamDistance),
      basis={
        {1,0,0},
        {0,1,0},
        initialCamZBasis -- also describes the camera vector and the normal to the 2d viewport plane!
      },
      size={x=1366, y=768}
    }
  }
}

return STATE