local cli = {}

function cli.yesNo(str)
  local answer
  
    io.write(str.." (y/n)\n")
    io.flush()
  repeat
    answer = io.read()
  until answer=="y" or answer=="n"
  print('answer', answer)
  if answer=="n" then
    return false
  end
  return true
end

return cli