---
---
--- File: lua_4400_ppp.lua
--- Handles ppp functions for 4400 and 4500 units
---
---
---
---



lua_4400_ppp = {}
---
--- This variable defines the serial port that is being used
---
---
lua_4400_ppp.serial_device = "/dev/ttyUSB0"



---
---
--- This function checks to see if a ppp connection is required and tries to establish it
--- If a ppp connection is required the ip of the connection is 125.2.2.80
---

function lua_4400_ppp.connect( chain, dev_4400, unitEntry, result)
  local  returnValue
  
  if ( unitEntry.tel ~= nil ) and ( unitEntry.tel ~= "" ) then
    if ( unitEntry.telext ~= nil ) and ( unitEntry.telext ~= "" ) then
      dev_4400.telphone = unitEntry.tel  .. unitEntry.telext
    else
      dev_4400.telephone = unitEntry.tel
       
    end
  else
    --- ssh address is the lan address
    dev_4400.ip = unitEntry.ip
    dev_4400.pp_control = nil
    return 1  -- there is no telephone hookup for this unit
  end

  if unitEntry.ppp_password == nil then
  
    dev_4400.ppp_user = chain["4400"].ppp_username
    dev_4400.ppp_password = chain["4400"].ppp_password
  else
    dev_4400.ppp_user = unitEntry.ppp_username
    dev_4400.ppp_password = unitEntry.ppp_password
   end
   ---
   --- At this point we need to do a ppp connect
   --- First check to make sure sufficient data has been present to do the connection
   ---
   assert( dev_4400.ppp_user ~= nil ,"need a ppp user name")
   assert( dev_4400.ppp_password ~= nil, "need a ppp password")
   assert( dev_4400.telephone ~= nil, "need a telephone number for ppp ")
   
   
   -- just in case ppp is already in use we kill it
   os.execute("killall pppd")
   os.execute("sleep 2")
   dev_4400.ip = "125.2.2.80"
   tempString = "pppd " ..lua_4400_ppp.serial_device.." 57600 user "..
                dev_4400.ppp_user.."  password "..dev_4400.ppp_password..
                " 125.2.2.85:125.2.2.80 connect "
    
   tempString = tempString.."'chat -v "..' "" ATQ0E0F1DT'..dev_4400.telephone..'  CONNECT ""'.."'"
   ---print(tempString)
   os.execute(tempString)
    
   dev_4400.ppp_control = {}
   dev_4400.ppp_control.status = status
   dev_4400.ppp_control.pid = pid
   dev_4400.ppp_control.readStream = readStream
   dev_4400.ppp_control.writeStream = writeStream
  
    returnValue = lua_4400_ppp.check_PPP_connection( 12, 5 ) -- check 12 times 5 second interval

  return returnValue
end




function lua_4400_ppp.disconnect( chain, dev_4400, actionResult )
  if dev_4400.ppp_control ~= nil then
    --- killing the ppp demon will terminate the line connectons
     os.execute("killall pppd")
    os.sleep(3)
    actionResult.status = actionResult.status .. "  Disconnecting modem"
    dev_4400.ppp_control = nil
  end
end




---
---
--- This function has the job of determining whether ppp0 network connection has been established
---
---
function lua_4400_ppp.grapIfconfig(  )
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


---
---
--- This function waits for the ppp0 connection to be present
--- tries is the number of times the ppp connection is checked
--- delay is the time between sampling
---
function lua_4400_ppp.check_PPP_connection( tries, delay )
   local status,data
   for i=1,tries do
     os.sleep( delay)
     status, data = lua_4400_ppp.grapIfconfig()
     if status == 1 then return 1 end
   end
   return 0
end
