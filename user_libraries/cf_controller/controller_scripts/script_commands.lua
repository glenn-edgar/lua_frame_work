---
---
---
--- File:  script_commands.lua
---
---
---




function cf_send_cmd.description()
 return "interface of commands to send to cf_controller"
end

function cf_send_cmd.help()
  print("List of controller commands ")
  print(".enableChain( nodeId, chainId) -- activates a chain")
  print(".disableChain(nodeId, chainId) -- deactivates a chain")
  print(".setOffLine( nodeId )  -- makes the controller off line")
  print(".setOnline( nodeId ) -- makes the controller on line")
  print(".setVar( nodeId, varType, var, value ) -- set controller variable")
  print( "  --- where varType  0 = app Variable 1 = alert variable 2 = eeprom variable")
  print(".getVar( nodeId, varType, var ) -- set controller variable")
  print( "  --- where varType  0 = app Variable 1 = alert variable 2 = eeprom variable")
  print(".to_timeStamp( time ) -- converts system time to time stamp")
  print(".to_time( timeStamp ) -- converts time to time stamp")

  print(".printReport( nodeId ) -- print System report ")
  print(".cf_erase( nodeId ) -- erases chain flow blocks\n -- system must be in offline state")
  print(".cf_add_chain( nodeId, chainId, autoStartFlag, startingMask ) -- defines start of chain")
  print(".cf_add_link( nodeId, opcode, parameter1, parameter2, parameter3) -- adds link element")
  print(".cf_mark_end( nodeId) -- marks end of chain ")
  print(".set_time( nodeId ) -- transfer computer time to cf_controller")
  print(".configure_io( nodeId, configurationId ) -- sets configurationId")
  print(".set_gpio( nodeId, gpio, gpio_value) -- sets gpio line")
  print(".read_gpio(nodeId,gpio,gpio_value) -- reads gpio line")
  print(".read_a_to_d(nodeId, a_d_channel) -- reads a/d value")
  print(".reset(nodeId) -- reset cf_controller")
  print(".to_timeStamp( time ) -- converts system time to time stamp")
  print(".to_time( timeStamp )-- converts time to time stamp")
  print(".help(nodeId) -- print out command list")
end

--
-- Converts System Time to time stamp
--  print( "where varType  0 = app Variable 1 = alert variable 2 = eeprom variable")
--
function cf_send_cmd.to_timeStamp( systemTime )
  local returnValue
  local temp
  if type( systemTime ) == "table" then
    temp = systemTime
  else
    temp = os.date ("*t" , systemTime)
  end
   returnValue = cf_send_cmd.to_timeStamp_lowLevel( temp.year,temp.month,temp.day,temp.hour,temp.min, temp.sec )
  return returnValue
end

function cf_send_cmd.to_time( timeStamp )
  local returnValue, year,month,day,hour,min,sec
  returnValue = {}
  year,month,day,hour,min,sec = cf_send_cmd.to_time_lowLevel( timeStamp )
  returnValue.year = year
  returnValue.month = month
  returnValue.day = day
  returnValue.hour = hour
  returnValue.min = min
  returnValue.sec = sec 
  return returnValue
end






function cf_send_cmd.enableChain( nodeId, chainId) 
  cf_send_cmd.pack("ENABLE_CHAIN",nodeId,chainId)
end
  

function cf_send_cmd.disableChain(nodeId, chainId)
 cf_send_cmd.pack("DISABLE_CHAIN",nodeId,chainId)
end 
function cf_send_cmd.setOffLine( nodeId ) 
 cf_send_cmd.pack("SET_OFFLINE",nodeId )
end
 
function cf_send_cmd.setOnline( nodeId )
 cf_send_cmd.pack("SET_ONLINE",nodeId)
end 
function cf_send_cmd.setVar( nodeId, varType, var, value )
 cf_send_cmd.pack("SET_VAR",nodeId,varType,var,value)
end 
function cf_send_cmd.getVar( nodeId, varType, var )
 cf_send_cmd.pack("GET_VAR",nodeId,varType,var)
end 
function cf_send_cmd.printReport( nodeId )
 cf_send_cmd.pack("PRINT_REPORT",nodeId)
end 
function cf_send_cmd.cf_erase( nodeId )
 cf_send_cmd.pack("CF_ERASE",nodeId)
end
 
function cf_send_cmd.cf_add_chain( nodeId, chainId, autoStartFlag, startingMask ) 
 cf_send_cmd.pack("CF_ADD_CHAIN",nodeId,chainId, autoStartFlag,startingMask)
end
function cf_send_cmd.cf_add_link( nodeId, opcode, parameter1, parameter2, parameter3)
 cf_send_cmd.pack("CF_ADD_LINK",nodeId,opcode,parameter1,parameter2,parameter3) 
end
function cf_send_cmd.cf_mark_end( nodeId)
 cf_send_cmd.pack("CF_MARK_END",nodeId)
end
function cf_send_cmd.set_time( nodeId ) 
 local temp
 temp = os.date("*t")
 cf_send_cmd.pack("SET_TIME",nodeId,temp.year,temp.month,temp.day,temp.hour,temp.min,temp.sec)
end
function cf_send_cmd.configure_io( nodeId, configurationId )
 cf_send_cmd.pack("CONFIGURE_IO",nodeId,configurationId)
end
function cf_send_cmd.set_gpio( nodeId, gpio, gpio_value)
 cf_send_cmd.pack("SET_GPIO",nodeId,gpio,gpio_value)
end

function cf_read_gpio(nodeId,gpio,gpio_value) 
  cf_send_cmd.pack("READ_GPIO",nodeId,gpio,gpio_value)
end

function cf_send_cmd.read_a_to_d(nodeId, a_d_channel)
 cf_send_cmd.pack("READ_A_TO_D",nodeId,a_d_channel) 
end
function cf_send_cmd.reset(nodeId) 
 cf_send_cmd.pack("RESET",nodeId)
end

function cf_send_cmd.pack( cmd, nodeId, p1,p2,p3,p4,p5,p6)
  local temp
  temp = "("..cmd.." "..nodeId.." "
  if p1 ~= nil then temp = temp ..p1.." " end
  if p2 ~= nil then temp = temp ..p2.." " end
  if p3 ~= nil then temp = temp ..p3.." " end
  if p4 ~= nil then temp = temp ..p4.." " end
  if p5 ~= nil then temp = temp ..p5.." " end
  if p6 ~= nil then temp = temp ..p6.." " end
  temp = temp .."  )"
  
  rs485.write(temp)
end
