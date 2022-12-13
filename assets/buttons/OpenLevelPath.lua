function OpenLevelPathOnClick()
  print('open layer path callback')
  ACTIVE_CONTROLS.textInput = true
  ACTIVE_CONTROLS.camera = false
  inputTextKey = "OpenLevelPath"
end

return {
  text="/",
  fontSize=12,
  bgColor={0,0,0,1},
  textColor={1,1,1,1},
  padding={x=20, y=20},
  onClick=function() OpenLevelPathOnClick() end
}