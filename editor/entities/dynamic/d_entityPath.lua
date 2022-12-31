local function update(self)
  if STATE.SELECTED_ENTITY_TYPE == nil and STATE.PROJECT ~= nil then
    project.selectNextEntityPath()
    STATE.INPUT_TEXT[self.inputTextKey] = 
      STATE.PROJECT.entities[STATE.SELECTED_ENTITY_TYPE][STATE.SELECTED_ENTITY_INDEX]
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
  inputTextKey="EntityPath",
  previousText="  "
}