local function update(self)
  if STATE.INPUT_TEXT[self.inputTextKey] == nil and STATE.PROJECT ~= nil then
    STATE.INPUT_TEXT[self.inputTextKey] = STATE.PROJECT.levels[1]
  end
  ui.updateText(self)
end

return {
  entityType="dynamic",
  assetType="UI",
  dimensions="2D",
  asset={
    text="  ",
    fontSize=12,
    bgColor={1,1,1,1},
    textColor={0,0,0,1},
    padding={x=20, y=20}
  },
  transform={0, 0},
  update=update,
  shape="rectangle",
  inputTextKey="LevelPath",
  previousText="  "
}