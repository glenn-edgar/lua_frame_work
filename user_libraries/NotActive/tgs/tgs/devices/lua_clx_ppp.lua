---
---
--- File: lua_clx_ppp.lua
--- Handles ppp connections for clx unit
---
---
---
---


lua_clx_ppp = {}

function lua_clx_ppp.connect( chain, clx_device, unitEntry, result)
  local status, pid, readStream, writeStream, username,password,phone, returnValue
  
  if ( unitEntry.tel ~= nil ) and ( unitEntry.tel ~= "" ) then
    if ( unitEntry.telext ~= nil ) and ( unitEntry.telext ~= "" ) then
      clx_device.telphone = unitEntry.tel .." , " .. unitEntry.telext
    else
      clx_device.telephone = unitEntry.tel
       
    end
  else
    --- ssh address is the lan address
    clx_device.ip = unitEntry.ip
    clx_device.pp_control = nil
    return 1  -- there is no telephone hookup for this unit
  end

  if unitEntry.ppp_password == nil then
  
    clx_device.ppp_user = chain.clx.ppp_username
    clx_device.ppp_password = chain.clx.ppp_password
  else
    clx_device.ppp_user = unitEntry.ppp_username
    clx_device.ppp_password = unitEntry.ppp_password
   end
   ---
   --- At this point we need to do a ppp connect
   --- First check to make sure sufficient data has been present to do the connection
   ---
   assert( clx_device.ppp_user ~= nil ,"need a ppp user name")
   assert( clx_device.ppp_password ~= nil, "need a ppp password")
   assert( clx_device.telephone ~= nil, "need a telephone number for ppp ")
   
   ---
   --- Kill extraneous pppd connections
   --- 
   os.execute("killall wvdial")
   os.execute("killall pppd")
   os.execute("sleep 2")
   username = "Username="..clx_device.ppp_user
   password = "Password="..clx_device.ppp_password
   phone    = "Phone="..clx_device.telephone
   clx_device.ip = "125.2.2.80"

   status, pid, readStream, writeStream = dpipe.open(5,"wvdial","--config","config/wvdial_clx.conf",username,password,phone)
   if pid ~= nil then
    clx_device.ppp_control = {}
    clx_device.ppp_control.status = status
    clx_device.ppp_control.pid = pid
    clx_device.ppp_control.readStream = readStream
    clx_device.ppp_control.writeStream = writeStream
  
    returnValue = lua_clx_ppp.check_PPP_connection( 12, 5 ) -- check 12 times 5 second interval
  else 
   print("could not connect modem")
   returnValue = 0
  end
  return returnValue
end

function lua_clx_ppp.disconnect( chain, clx_device, actionResult )
  if clx_device.ppp_control ~= nil then
    dpipe.close( clx_device.ppp_control.pid, 
                 clx_device.ppp_control.readStream,
                 clx_device.ppp_control.writeStream) 
    os.execute("killall pppd")
    os.sleep(2)
    actionResult.status = actionResult.status .. "  Disconnecting modem"
    clx_device.ppp_control = nil
  end
end


function lua_clx_ppp.grapIfconfig(  )
 local connectionFlag,ij
  local temp -- response from file
  local handle -- popen handle
 
  temp = ""
  handle = io.popen("/sbin/ifconfig ")
  if handle == nil then
     connectionFlag = 0
  else
    
     temp = handle:read("*all")
     i,j = string.find(temp,"ppp0")
     if i ~= nil then connectionFlag = 1 else connectionFlag = 0 end
     handle:close()

  end

  return connectionFlag, temp
end  

function lua_clx_ppp.check_PPP_connection( tries, delay )
   local status,data
   for i=1,tries do
     os.sleep( delay)
     status, data = lua_clx_ppp.grapIfconfig()
     if status == 1 then return 1 end
   end
   return 0
end
  