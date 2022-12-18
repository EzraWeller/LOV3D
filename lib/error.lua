local error = {}

function error.new(type, message)
  print("LOV3D error : "..type.." : "..message)
  return {
    type=type,
    message=message
  }
end

return error