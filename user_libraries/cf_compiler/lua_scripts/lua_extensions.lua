---
---
--- lua_extensions.lua
--- This file implements a network/ file version of the cf compiler
---
---
---

cf_compiler = {}

cf_compiler.currentCount = 0
cf_compiler.fileNumber = 0
cf_compiler.outFile = nil
cf_compiler.linkCount = 0
cf_compiler.chainMap = {}
cf_compiler.numberOfChains = 0
cf_compiler.numberOfLinks  = 0



function cf_compiler.setOutput( fileNumber )
  local fileName
  if outFile ~= nil then
    io.close( outFile )
  end
  fileName = "../chain/"..fileNumber..".bas"
  print(fileName)
  outFile = io.open (fileName,"w+")
  assert( outFile ~= nil )
  print(outFile)
end


function cf_compiler.setClose()
  if outFile ~= nil then io.close(outFile) end
end


function cf_compiler.dumpChainMap()
 local temp
 temp = {}
 for i,j in pairs( chainMap ) do
   table.insert( temp,i)
 end
 table.sort(temp)

 for i,k in ipairs( temp ) do
  j = chainMap[k]
  if j.description == nil then j.description ="" end
  print("chain#",j.chainId,"a_start",j.autoStart,"mask",j.mask,j.description)
 end
end



function cf_compiler.dumpStatistics()
 print("number of chains ",numberOfChains)
 print("number of links  ",numberOfLinks)
 dumpChainMap()
end


function cf_compiler.outputLine( opcode, cmd, parm1, parm2, parm3 )
  local lineOutput
  lineOutput = opcode.." 0 ".. cmd .." "
  if parm1 ~= nil then lineOutput = lineOutput.. "  " .. parm1
  else lineOutput = lineOutput .. " ".. tostring(0 ) end
  if parm2 ~= nil then lineOutput = lineOutput.. "  ".. parm2
  else lineOutput = lineOutput .. " ".. tostring(0) end
  if parm3 ~= nil then lineOutput = lineOutput.. "  ".. parm3
  else lineOutput = lineOutput .. " ".. tostring(0 ) end
  currentCount = currentCount +1
  lineOutput = lineOutput .."\n"
  outFile:write (lineOutput)
end












function cf_compiler.eraseFlash()

 outFile:write ("CF_ERASE 0 ".."\n" )
 currentCount = currentCount +1

end

function cf_compiler.startChain( chainId, autoStart, startingMask,description )
 print("starting chain",chainId)
 linkCount = 0
 numberOfChains = numberOfChains +1
 assert(chainMap[chainId] == nil )
 chainMap[chainId] = {}
 chainMap[chainId].autoStart = autoStart
 chainMap[chainId].mask      = startingMask
 chainMap[chainId].description = description
 chainMap[chainId].chainId = chainId
 outFile:write ("CF_ADD_CHAIN  0 " ..chainId.." "..autoStart.." "..startingMask.."  \n")
end

function cf_compiler.addLink( opcode, parm1, parm2, parm3 )
numberOfLinks = numberOfLinks + 1
print("adding link", linkCount,"opcode",opcode)
assert( linkCount < 8 )
outputLine("CF_ADD_LINK  ",opcode,parm1, parm2, parm3 )
linkCount = linkCount +1
end

function cf_compiler.endChain( )
 print("ending chain ")
 linkCount = 0
 outFile:write ("CF_MARK_END 0 " .."\n")

 currentCount = currentCount +1


end




function  cf_compiler.haltChain()
addLink("HALT" )
end

function  cf_compiler.resetChain()
addLink("RESET" )
end

function  cf_compiler.stopChain()
addLink("STOP" )
end

function  cf_compiler.enableChain( start_chain, end_chain )
addLink("ENABLE_CHAIN" ,start_chain,end_chain,chain)
end

function  cf_compiler.disableChain( chain1, chain2, chain3 )
addLink("DISABLE_CHAIN",chain1,chain2,chain3 )
end

function  cf_compiler.delay( seconds)
 addLink("DELAY" , seconds )
end

function  cf_compiler.waitEvent( event )
addLink("WAIT_EVENT", event )
end

function  cf_compiler.waitBoolean( appVariable, boolstate )
addLink("WAIT_BOOLEAN",appVariable, boolstate )
end



function  cf_compiler.waitAnalog( appVariable, appVar_highlimit, appVar_lowLimit )
addLink("WAIT_ANALOG",appVariable, appVar_highlimit, appVar_lowLimit )
end

function  cf_compiler.waitHour( appVariable, highlimit, lowLimit )
addLink("WAIT_HOUR",appVariable, highlimit, lowLimit )
end

function  cf_compiler.waitMinute( appVariable, highLimit, lowLimit )
addLink("WAIT_MINUTE",appVariable, highLimit, lowLimit )
end

function  cf_compiler.waitSecond( appVariable, highLimit, lowLimit )
addLink("WAIT_SECOND",appVariable, highLimit, lowLimit )
end

function  cf_compiler.monitorBoolean( appVariable, limit)
addLink("MONITOR_BOOLEAN",appVariable, limit)
end

function  cf_compiler.monitorAnalog( appVariable, appVariablehighLimit, appVariablelowLimit )
addLink("MONITOR_ANALOG",appVariable, appVariablehighLimit, appVariablelowLimit )
end

function  cf_compiler.setGPIO( channel,value, appVariable )
addLink("SET_GPIO",channel, value, appVariable )
end



function  cf_compiler.readGPIO( channel, appVariable )
addLink("READ_GPIO",channel, appVariable )
end

function  cf_compiler.read_A_to_D( channel, appVariable )
addLink("READ_A_to_D",channel, appVariable )
end


function  cf_compiler.strobeWatchDog()
addLink("STROBE_WATCHDOG")
end

function cf_compiler.delay_100(delay)
addLink("DELAY_100",delay)
end

function cf_compiler.debounce_read_GPIO( count, channel, appVariable)
addLink("DEBOUNCE",count,channel,appVariable)
end

function cf_compiler.filter_read_A_to_D( count, channel, appVariable)
addLink("FILTER_A_D",count,channel,appVariable)
end



function  cf_compiler.setNode( nodeId )
addLink("SET_NODE",nodeId )
end

function  cf_compiler.setFlash( id , value )
addLink("SET_FLASH",parm1, parm2, parm3 )
end

function  cf_compiler.setFlashNotInt( id, value )
addLink("SET_FLASH_NINT",id, value )
end




function  cf_compiler.setAlert( alertId )
addLink("SET_ALERT",alertId )
end

function  cf_compiler.clearAlert( alertId )
addLink("CLEAR_ALERT", alertId )
end

function  cf_compiler.configureIo( ioConfiguration )
addLink("CONFIGURE_IO",ioConfiguration )
end

function cf_compiler.monitorAlert( alertId , state) -- insures alert is free
addLink("MONITOR_ALERT", alertId ,state)
end

function cf_compiler.waitAlert( alertId, state ) -- insures alert at a given state
addLink("WAIT_ALERT", alertId, state )
end

cf_compiler.COUNTER_SET = 0
cf_compiler.COUNTER_CLEAR = 1
cf_compiler.COUNTER_INCREMENT = 2
cf_compiler.COUNTER_DECREMENT = 3

function cf_compiler.counter( action, appVariable, value)
 if value == nil then value = 1 end
 addLink("COUNTER",action, appVariable, value )
end

function cf_compiler.wait_hour_app( appVariable, appVariable_highlimit, appVariable_lowLimit )
 addLink("WAIT_HOUR_APP",appVariable, appVariable_highlimit, appVariable_lowLimit )
end

function cf_compiler.wait_minute_app( appVariable, appVariable_highlimit, appVariable_lowLimit )
 addLink("WAIT_MINUTE_APP",appVariable, appVariable_highlimit, appVariable_lowLimit )
end

function cf_compiler.wait_second_app( appVariable, appVariable_highlimit, appVariable_lowLimit )
 addLink("WAIT_SECOND_APP",appVariable, appVariable_highlimit, appVariable_lowLimit )
end


function cf_compiler.wait_monitor_boolean( appVariable, booleanState )
 addLink("WAIT_MONITOR_BOOLEAN",appVariable, booleanState )
end


function cf_compiler.wait_monitor_analog( appVariable, appVariable_highlimit, appVariable_lowLimit )
 addLink("WAIT_MONITOR_ANALOG",appVariable, appVariable_highlimit, appVariable_lowLimit )
end


function cf_compiler.wait_monitor_alert( alert_variable, boolean_state)
 addLink("WAIT_MONITOR_ALERT", alert_variable, boolean_state)
end


function cf_compiler.and_alert_bits( appVariable, startingBits, endingBits )
 addLink("AND_ALERT_BITS",appVariable, startingBits, endingBits )
end


function cf_compiler.or_alert_bits( appVariable, startingBits, endingBits )
 addLink("OR_ALERT_BITS",appVariable, startingBits, endingBits )
end


function cf_compiler.move_from_flash( appVariable, flashVariable )
 addLink("MOVER_FROM_FLASH",appVariable, flashVariable )
end

function cf_compiler.transfer( drive)
 local path = drive.."\\chain"
  os.execute("del "..path.."\\*.bsx")
  os.execute("del "..path.."\\*.bas")
  os.execute("copy  ..\\chain\\*.bas".."  ".. path)
end

function cf_compiler.help()
  print("TDB print help statements")
end

function cf_compiler.description()
  return "Chain flow network compiler "
end
