---
--- File: lua_clx.lua
--- 
---  This file implements the tgs actions for CLX devices
---
---
---
---

clx_device = {}
clx_device.ssh_stream = {}


--
-- register common code drivers
--
clx_device.ECHO        = common_device_code.ECHO
clx_device.TIME_DELAY  = common_device_code.TIME_DELAY
clx_device.PING        = common_device_code.PING
clx_device.PING_GATEWAY = common_device_code.PING_GATEWAY


function clx_device.INIT( )

clx_device.ssh_stream = {}
end


function clx_device.CONNECT( parameters, actionResult, chain, unitEntry )
   --- set password

  --- this is an assert because
  --- problem in driving script
  --- trying to connect with out a disconnect
  
  assert( clx_device.ssh_stream.pid == nil , "trying to open an open stream")
  
  actionResult.status =  lua_clx_ppp.connect( chain, clx_device, unitEntry ,actionResult.result)
 
  if actionResult.status ~= 1 then
  
   return actionResult.status 
  end

  if unitEntry.ssh_password == nil then
    clx_device.user = chain.clx.ssh_username
    clx_device.password = chain.clx.ssh_password
  else
    clx_device.user = unitEntry.ssh_username
    clx_device.password = unitEntry.ssh_password
   end
   
   ---
   --- This is an assert because unit data base is messed up
   ---
   ---
   assert( clx_device.user ~= nil, "ssh connection requires user")
   assert( clx_device.password ~= nil, "ssh connection requires password")
   assert( unitEntry.ip ~= nil,"ssh connection requires ipaddress")
   
   tgs_ssh.setPassword( clx_device.password)
   --- 
   clx_device.ssh_stream = {}
   actionResult.status = tgs_ssh.connect( clx_device.user, clx_device.ip, clx_device.ssh_stream )
  
   actionResult.result.status = "connection to "..unitEntry.ip 
   if actionResult.status == 0 then
     actionResult.result.status = "bad connection for ip  ".. clx_device.ip
     clx_device.ssh_stream = {}
   end
   return actionResult.status
end

function clx_device.DISCONNECT(parameters, actionResult, chain, unitEntry )
   if clx_device.ip == nil then clx_device.ip = "bad ppp connection" end
 
   actionResult.status = true
   actionResult.result.status = "disconnecting ".. clx_device.ip
   tgs_ssh.disconnect( clx_device )
   clx_device.ssh_stream = {}
   lua_clx_ppp.disconnect( chain, clx_device, actionResult.result )
   return actionResult.status
end


function clx_device.GET_FILE(parameters, actionResult, chain, unitEntry )
  local getFile, temp

  tgs_ssh.setPassword( clx_device.password)
  getFile = clx_device.parseUnitReplacement( chain, unitEntry, parameters[2])
  actionResult.status, temp = 
     tgs_ssh.getFile( clx_device.user, clx_device.ip, parameters[1], getFile )
  
  actionResult.result.status = "got file "..getFile.." from remote unit  ".. temp
  actionResult.result.tgsFile = parameters[1]
  actionResult.result.mtsFile = getFile
 
  getFile = nil
  temp = nil
  return actionResult.status
end

function clx_device.PUT_FILE(parameters, actionResult, chain, unitEntry )
  local sendFile, temp
  tgs_ssh.setPassword( clx_device.password)
  sendFile = clx_device.parseUnitReplacement( chain, unitEntry, parameters[1] )
  
  actionResult.status, temp = 
     tgs_ssh.sendFile( clx_device.user, clx_device.ip, parameters[2] ,sendFile )
  actionResult.result.status = "set file "..sendFile.." to remote units  "..temp
  actionResult.result.tgsFile = parameters[2]
  actionResult.result.mtsFile = sendFile

  sendFile = nil
  return actionResult.status
end

function clx_device.GET_TIME(parameters, actionResult, chain, unitEntry, timeCorrection )
 tgs_ssh.setPassword( clx_device.password)
  if timeCorrection == nil then timeCorrection = false end
  actionResult.result.timeCorrection = timeCorrection
  actionResult.result.tgsTime = os.time()
  actionResult.status, actionResult.result.mtsTime = tgs_ssh.sendCommand( clx_device,'date +"%s" ')
  actionResult.result.mtsTimeString = actionResult.result.mtsTime
  actionResult.result.mtsTime = tonumber( actionResult.result.mtsTime)
  return actionResult.status
end

function clx_device.SET_TIME(parameters, actionResult, chain, unitEntry )
  local timeString , status1, status2

  tgs_ssh.setPassword( clx_device.password)
  clx_device.GET_TIME(parameters, actionResult, chain, unitEntry, true )  

  timeString = tgs_time.generateTime()
   
  actionResult.result.timeString = timeString
  status1 = tgs_ssh.sendString( clx_device , "date -us "..timeString )
  
  if status1 > 0 then
    status2 =  tgs_ssh.sendString(clx_device, "hwclock -wu  ")
    actionResult.result.status =  "set time and  hwclock -wu"
    actionResult.status = status2
  else
    actionResult.status = 0
    actionResult.result.status = "bad date command"
  end
  return actionResult.status
end

function clx_device.GET_VERSION(parameters, actionResult, chain, unitEntry )
 tgs_ssh.setPassword( clx_device.password)
 actionResult.status, actionResult.result.data 
        = tgs_ssh.sendCommand( clx_device ,"cat /usr/shoptalk/logs/info.log ")
 
 actionResult.result.status = "action ok"
 return actionResult.status
end

function clx_device.REBOOT( parameter, actionResult, chain, unitEntry )
     tgs_ssh.setPassword( clx_device.password)
     tgs_ssh.reboot( clx_device )
     clx_device.ssh_stream = {}
     actionResult.status = 1
     actionResult.result.status = "rebooting clx"
     return 1
end

function clx_device.PS(parameter, actionResult, chain, unitEntry )
tgs_ssh.setPassword( clx_device.password)
 actionResult.status, actionResult.result.data 
        = tgs_ssh.sendCommand( clx_device ,"ps  ")
 actionResult.result.status = "action ok"
 return actionResult.status
end


function clx_device.PROC(parameter, actionResult, chain, unitEntry )
 local procFile

 procFile = parameter[1]
 tgs_ssh.setPassword( clx_device.password)
 actionResult.status, actionResult.result.data 
        = tgs_ssh.sendCommand( clx_device ,"cat /proc/"..procFile)
 actionResult.result.status = "action ok"
 return actionResult.status
end


function clx_device.help()
 print("implements clx tgs commands")
end

function clx_device.description()
  return "implements clx tgs commands"
end

function clx_device.parseUnitReplacement( chain, unitEntry, fileName )
   local key
   local unitName
   local match
   local returnValue

   match = "$unit"
   key = chain.key
   unitName = unitEntry[ key]
   if string.find( fileName, match ) ~= nil then
    returnValue = string.gsub(fileName, match, unitName )
   else
    returnValue = fileName
   end
   return returnValue
end


devices.addDevice( "clx", clx_device)


