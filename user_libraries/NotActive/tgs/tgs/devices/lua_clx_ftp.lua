---
--- File: lua_clx.lua
--- 
---  This file implements the tgs actions for CLX devices
---
---
---
---

clx_device_ftp = {}
clx_device_ftp.ssh_stream = {}


--
-- register common code drivers
--
clx_device_ftp.ECHO        = common_device_code.ECHO
clx_device_ftp.TIME_DELAY  = common_device_code.TIME_DELAY
clx_device_ftp.PING        = common_device_code.PING
clx_device_ftp.PING_GATEWAY = common_device_code.PING_GATEWAY
---
---
--- Get Commands from clx base device
---
---

clx_device_ftp.parseUnitReplacement = clx_device.parseUnitReplacement
 

function clx_device_ftp.INIT( )

clx_device_ftp.ssh_stream = {}
end


function clx_device_ftp.CONNECT( parameters, actionResult, chain, unitEntry )
  
  clx_device_ftp.passwords = {}

  actionResult.status =  lua_clx_ppp.connect( chain, clx_device, unitEntry ,actionResult.result)
 
  if actionResult.status ~= 1 then
  
   return actionResult.status 
  end

  if unitEntry.ssh_password == nil then
    clx_device_ftp.user = chain.clx.ssh_username
    clx_device_ftp.password = chain.clx.ssh_password
  else
    clx_device_ftp.user = unitEntry.ssh_username
    clx_device_ftp.password = unitEntry.ssh_password
   end

   clx_device_ftp.setPassWords()


   
   ---
   --- This is an asser to check that unit.db is not messed up
   ---
   ---
   assert( clx_device_ftp.user ~= nil, "ssh connection requires user")
   assert( clx_device_ftp.password ~= nil, "ssh connection requires password")
   assert( unitEntry.ip ~= nil,"ssh connection requires ipaddress")
   clx_device_ftp.ip = unitEntry.ip
   tgs_ssh.setPassword( clx_device_ftp.password)
   --- 
   clx_device_ftp.ssh_stream = {}
   actionResult.status = tgs_ssh.connect( clx_device_ftp.user, clx_device_ftp.ip, clx_device_ftp.ssh_stream )
  
   actionResult.result.status = "connection to "..unitEntry.ip 
   if actionResult.status == 0 then
     actionResult.result.status = "bad connection for ip  ".. clx_device_ftp.ip
     clx_device_ftp.ssh_stream = {}
   end
   return actionResult.status
end




function clx_device_ftp.DISCONNECT(parameters, actionResult, chain, unitEntry )
   if clx_device_ftp.ip == nil then clx_device_ftp.ip = "bad ppp connection" end
 
   actionResult.status = true
   actionResult.result.status = "disconnecting ".. clx_device_ftp.ip
   tgs_ssh.disconnect( clx_device_ftp )
   clx_device_ftp.ssh_stream = {}
   lua_clx_ppp.disconnect( chain, clx_device_ftp, actionResult.result )
   return actionResult.status
end





function clx_device_ftp.GET_FILE(parameters, actionResult, chain, unitEntry )
  local getFile
  
  getFile = clx_device_ftp.parseUnitReplacement( chain, unitEntry, parameters[2])

   actionResult.status = curl.ftpGet( clx_device_ftp.passwords.ftp_user,
                                      clx_device_ftp.passwords.ftp_password,
                                      clx_device_ftp.ip,
                                      getFile, parameters[1] )
   
  actionResult.result.mtsFile = parameters[1]
  actionResult.result.tgsFile = getFile
  actionResult.result.status = actionResult.status
  if actionResult.status == 0 then
    actionResult.status = true
  else
    actionResult.status = false
  end
 
  getFile = nil
  return actionResult.status
end
 
function clx_device_ftp.PUT_FILE(parameters, actionResult, chain, unitEntry )
  local sendFile
 
  sendFile = clx_device_ftp.parseUnitReplacement( chain, unitEntry, parameters[1] )
  
   actionResult.status = curl.ftpPut( clx_device_ftp.passwords.ftp_user,
                                      clx_device_ftp.passwords.ftp_password,
                                      clx_device_ftp.ip,
                                      sendFile, parameters[2] )
   
  actionResult.result.mtsFile = parameters[2]
  actionResult.result.tgsFile = sendFile
  actionResult.result.status = actionResult.status
  if actionResult.status == 0 then
    actionResult.status = true
  else
    actionResult.status = false
  end
 
  getFile = nil
  return actionResult.status
end




function clx_device_ftp.GET_VERSION(parameters, actionResult, chain, unitEntry )
 tgs_ssh.setPassword( clx_device_ftp.password)
 actionResult.status, actionResult.result.data 
        = tgs_ssh.sendCommand( clx_device_ftp ,"cat /usr/shoptalk/logs/info.log ")
 
 actionResult.result.status = "action ok"
 return actionResult.status
end


function clx_device_ftp.REBOOT( parameter, actionResult, chain, unitEntry )
     tgs_ssh.setPassword( clx_device.password)
     tgs_ssh.reboot( clx_device )
     clx_device.ssh_stream = {}
     actionResult.status = 1
     actionResult.result.status = "rebooting clx"
     return 1
end

function clx_device_ftp.PS(parameter, actionResult, chain, unitEntry )
tgs_ssh.setPassword( clx_device_ftp.password)
 actionResult.status, actionResult.result.data 
        = tgs_ssh.sendCommand( clx_device_ftp ,"ps  ")
 actionResult.result.status = "action ok"
 return actionResult.status
end


function clx_device_ftp.PROC(parameter, actionResult, chain, unitEntry )
 local procFile

 procFile = parameter[1]
 tgs_ssh.setPassword( clx_device_ftp.password)
 actionResult.status, actionResult.result.data 
        = tgs_ssh.sendCommand( clx_device_ftp ,"cat /proc/"..procFile)
 actionResult.result.status = "action ok"
 return actionResult.status
end

function clx_device_ftp.GET_TIME(parameters, actionResult, chain, unitEntry, timeCorrection )
 tgs_ssh.setPassword( clx_device_ftp.password)
  if timeCorrection == nil then timeCorrection = false end
  actionResult.result.timeCorrection = timeCorrection
  actionResult.result.tgsTime = os.time()
  actionResult.status, actionResult.result.mtsTime = tgs_ssh.sendCommand( clx_device_ftp,'date +"%s" ')
  actionResult.result.mtsTimeString = actionResult.result.mtsTime
  if actionResult.result.mtsTime ~= nil then
    
    actionResult.result.mtsTime = tonumber( actionResult.result.mtsTime)
  else
    actionResult.status = false
  end
  return actionResult.status
end

function clx_device_ftp.SET_TIME(parameters, actionResult, chain, unitEntry )
  local timeString , status1, status2

  tgs_ssh.setPassword( clx_device_ftp.password)
  clx_device_ftp.GET_TIME(parameters, actionResult, chain, unitEntry, true )  

  timeString = tgs_time.generateTime()
   
  actionResult.result.timeString = timeString
  status1 = tgs_ssh.sendString( clx_device_ftp , "date -us "..timeString )
  
  if status1 > 0 then
    status2 =  tgs_ssh.sendString(clx_device_ftp, "hwclock -wu  ")
    actionResult.result.status =  "set time and  hwclock -wu"
    actionResult.status = status2
  else
    actionResult.status = 0
    actionResult.result.status = "bad date command"
  end
  return actionResult.status
end


----
----
---- Support routines
----
----
----
----
----






function clx_device_ftp.description()
  return "implements clx ftp tgs commands"
end



function clx_device_ftp.setPassWords()
     
      clx_device_ftp.passwords.ftp_user            = Target["4500"].ftp_username
      clx_device_ftp.passwords.ftp_password        = Target["4500"].ftp_password
      clx_device_ftp.passwords.telnet_user         = Target["4500"].telnet_username
      clx_device_ftp.passwords.telnet_password     = Target["4500"].telnet_password
      clx_device_ftp.passwords.telnet_port         = Target["4500"].telnet_port  
      assert(clx_device_ftp.passwords.ftp_user ~= nil, "missing ftp user name")
      assert(clx_device_ftp.passwords.ftp_password ~= nil,"missing ftp password")
      assert( clx_device_ftp.passwords.telnet_user ~= nil, "missing telnet user name")
      assert( clx_device_ftp.passwords.telnet_password ~= nil,"missing telnet password")
      assert( clx_device_ftp.passwords.telnet_port ~= nil,"missing telnet port")
      

end
devices.addDevice( "clx_ftp", clx_device_ftp )


