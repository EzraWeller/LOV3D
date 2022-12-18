local cli = {}

function cli.yesNo(str)
  local answer
  repeat
    io.write(str.." (y/n)\n")
    io.flush()
    answer = io.read()
  until answer=="y" or answer=="n"
  if answer=="n" then
    return false
  end
  return true
end

return cli