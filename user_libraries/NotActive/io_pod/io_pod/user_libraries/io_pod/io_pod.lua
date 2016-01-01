---
---
--- file: io_pod.lua
--- Design Notes:
--- 
--- Built in commands
--- 0 = directory Number
--- 1 = fetch directory Names, Index, Number
---
---

pod_cmds         = {}

function pod_cmds.descripition()
 return "high level pod commands"
end

function pod_cmds.help()

  print("pod commands are as follows")
  print(".open( drivePath ) -- returns handle ")
  print(".close(handle)           -- closes handle ")
  print(".clear(handle)           -- clear pod commands")
  print(".write( handle )    -- send pod commands ")
  print(".read( handle )  -- reads and parses pod")
  print(".version( handle ) -- retrieves pod version ")
  print(".configPio(handle, directionMask) -- configures direction of pio")
  print(".readPio( handle ) -- reads gpio port ")
  print(".setPio(handle,pioValue) --- sets pio value")
  print(".setRtc()  -- sets current time to rtc ")
  print(".rtcTick(x) -- x is enable flag  ")
  print(".rtcAlarmSet( year,month,day,hour,sec,gpioValue ) -- set rtc alarm")
  print(".rtcAlarmClear() -- clear rtc alarm ")
  print(".readAtoD(handle) --   ")
  print(".writeDac( handle,dacValue ) --   ")
  print(".setPWMFreq( handle,freq ) --")
  print(".setPWM( handle,index, value )")
  print(".setUARTBaud( handle, baudrate)")
  print(".writeUART( handle,data )" )
  print(".readUART( handle,data )" )
  print(".enableI2C( handle, clock )")
  print(" --- fill in I2C commands ")
end


function pod_cmds.open( drivePath )

  handle = {} 
  handle.list = {}
  handle.events = {}

  handle.file = drivePath
  handle.readHandle, handle.writeHandle = io_pod.open( drivePath)
  if handle.writeHandle < 0 then
    handle = nil

  end
  return handle
end

function pod_cmds.close(handle)

   if handle.readHandle > 0  then
    io_pod.close( handle.readHandle, handle.writeHandle )
    handle.readHandle = -1
    handle.writeHandle = -1
   end

end

function pod_cmds.clear(handle )
  if handle.handle > 0 then
    handle.list = {}
  end
end


---
---
--- Reads and parses pod RX Messages
---
function pod_cmds.read( handle)
  local data, temp, dataSize, returnValue, tempElement
  returnValue = {}
  dataSize, data = io_pod.read(handle.readHandle )
  print("read",dataSize,data)
  temp = string.split( data,";")
  if #temp < 2 then return end
  for i,j in ipairs( temp ) do
    tempElement = pod_cmds.processLine( handle, j)
    if tempElement ~= nil then
      table.insert( returnValue, tempElement)
    end 
  end
  return returnValue
end




function pod_cmds.write( handle )
 local temp
 
 if #handle.list > 0 then
   temp = table.concat( handle.list)

   --handle.readHandle, handle.writeHandle = io_pod.open( handle.file)
   status = io_pod.write(handle.writeHandle, temp)
   --pod_cmds.close(handle)
   print("status",status)
   handle.list = {}
 end
end


---

function pod_cmds.version(handle)
 local temp
 temp = sprintf("%s:-:;","VER")
 table.insert(handle.list,temp)
end

function pod_cmds.dir(handle ) 
  -- tbd
end

function pod_cmds.configPio(handle, directionMask)
 local temp
 temp = sprintf("%s:i:%d;","CONF_PIO",directionMask)
 table.insert(handle.list,temp)
end
 
function pod_cmds.readPio( handle )
 local temp
 temp = sprintf("%s:-:;","GET_PIO")
 table.insert(handle.list,temp)
end

function pod_cmds.setPio(handle, pioValue)
 local temp
 temp = sprintf("%s:i:%d;","SET_PIO",pioValue)
 table.insert(handle.list,temp)
end

function pod_cmds.setRtc()
 local temp, temp1
 temp1 = os.date("*t")
 temp = sprintf("%s:iiiiiii:%d,%d,%d,%d,%d,%d,%d;","RTC_SET",temp1.year,temp1.month,temp1.day,temp1.hour,temp1.min, temp1.sec,gpioValue)
 table.insert(handle.list,temp)

end

function pod_cmds.readRtc()
 local temp
 temp = sprintf("%s:-:;","RTC_READ")
 table.insert(handle.list,temp)


end



function pod_cmds.rtcTick(x) -- x is enable flag 
 local temp
 temp = sprintf("%s:i:%d;","RTC_TICK",x)
 table.insert(handle.list,temp)
 
end

function pod_cmds.rtcAlarmSet( year,month,day,hour,minute,sec,gpioValue ) -- set rtc alarm
 local temp
 temp = sprintf("%s:iiiiiii:%d,%d,%d,%d,%d,%d,%d;","RTC_ALARM_SET",year,month,day,hour,minute,sec,gpioValue)
 table.insert(handle.list,temp)

end

function pod_cmds.rtcAlarmClear() -- clear rtc alarm 
 local temp
 temp = sprintf("%s:-:;","RTC_ALARM_CLEAR")
 table.insert(handle.list,temp)

end




function pod_cmds.readAtoD( handle ) 
end

function pod_cmds.writeDac( handle, dacValue ) 
end

function pod_cmds.setPWMFreq( handle, freq ) 
end

function pod_cmds.setPWM( handle, index, value )
end

function pod_cmds.setUARTBaud( handle, baudrate)
end

function pod_cmds.writeUART( handle, data )
end

function pod_cmds.readUART( handle, data )
end

function pod_cmds.enableI2C( handle, clock )
end

----
---- flush out I2C commands
----


---
---
--- Internal Commands
---
---
---
---
function pod_cmds.processLine( handle, j)
  local command
  local format
  local data
  local dataList
  local temp

  temp = string.split( j, ":")
  if #temp < 3  then return end
  command = temp[1]
  format  = temp[2]
  data    = temp[3]
  
  dataList = string.split(data,",")
  handle.events[ command ] = {}

  for i,j in ipairs( dataList ) do
    tempType = io_pod.getFormat(i,format)
    if tempType == 0 then -- integer
      table.insert( handle.events[command], tonumber(j) )
    end
    if tempType == 1 then -- string
      table.insert(handle.events[command], j)
    end
    if tempType == 2 then -- ascii64 string
      table.insert( handle.events[command], base64.decode( j ) )
    end
  end
  return command
end
  


    