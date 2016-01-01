---
--- File: tgs_ssh.lua
--- lua interface to dropbear ssh client
---
---
---
---



tgs_ssh = {}

function tgs_ssh.help()
end


function tgs_ssh.description()
 return "tgs ssh functions"
end



function tgs_ssh.setPassword( password)
 tgs_ssh.password = password
  os.putenv("TGS_PASSWORD="..tgs_ssh.password )
  --print("getevn",os.getenv("TGS_PASSWORD"))
end


function tgs_ssh.connect(  user,address, ssh_stream )
   local status
   status = 1 --- assume success
 
   return status
end


function tgs_ssh.disconnect(ssh_stream)
   return 1 -- success
end


function tgs_ssh.reboot( clx_device )

  return tgs_ssh.sendString( clx_device,"reboot  \n")

end


function tgs_ssh.sendString( clx_device, command )
  local connectionFlag,ij
  local temp -- response from file
  local handle -- popen handle
 
  temp = ""
  handle = io.popen("./dbclient  "..clx_device.user.."@"..clx_device.ip.."  "..command )
  if handle == nil then
     connectionFlag = 0
  else
     handle:close()
     connectionFlag = 1
  end

  return connectionFlag
end

function tgs_ssh.sendCommand( clx_device , command )
  local connectionFlag,ij
  local temp -- response from file
  local handle -- popen handle
 
  temp = ""
  --os.execute("chmod 777 test.out")
  os.execute("./samplessh "..clx_device.user.."@"..clx_device.ip.."  "..command.." >test.out ")
 
  handle = io.open("test.out","r")
  if handle == nil then
     connectionFlag = 0
  else
  
     temp = handle:read("*all")
     --i,j = string.find(temp,"SUCCESS---")
     --if i ~= nil then connectionFlag = 1 else connectionFlag = 0 end
     handle:close()
     connectionFlag = 1
     
  end

  return connectionFlag, temp
end

function tgs_ssh.sendFile( user,address, tofile, fromfile )
  local connectionFlag,ij
  local temp -- response from file
  local handle -- popen handle
 
  temp = ""
  handle = io.popen("./scp "..fromfile.." "..user.."@"..address..":"..tofile )
  if handle == nil then
     connectionFlag = false
  else
    
     temp = handle:read("*all")
     i,j = string.find(temp,"SUCCESS---")
     if i ~= nil then connectionFlag = 1 else connectionFlag = 0 end
     handle:close()
  end

  return connectionFlag, temp
end




function tgs_ssh.getFile( user,address,fromFile  , toFile )
  local connectionFlag,i,j
  local temp -- response from file
  local handle -- popen handle
  
  temp = ""
  handle = io.popen("./scp  "..user.."@"..address..":"..fromFile.." "..toFile )
  if handle == nil then
     connectionFlag = false
  else

     temp = handle:read("*all")
     handle:close()
     i,j = string.find(temp,"SUCCESS---")
     if i ~= nil then connectionFlag = 1 else connectionFlag = 0 end

  end
 
  return connectionFlag, temp
end