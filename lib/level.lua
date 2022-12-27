local level = {}

function level.load(fileName)
  local mainLevel = json.decode(io.input("levels/"..fileName, "r"):read("a"))
  local editorLevel = json.decode(io.input("editor/levels/l_editor.json", "r"):read("a"))
  table.insert(mainLevel.layers, editorLevel.layers[1])
  print('full level', json.encode(mainLevel))
  STATE.LEVEL = mainLevel
  load.entities()
end

return level