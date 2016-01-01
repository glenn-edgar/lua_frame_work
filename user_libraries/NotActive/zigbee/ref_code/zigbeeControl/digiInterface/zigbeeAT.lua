---
---
--- File: zigbeeAT.lua
--- Builds zigbee AT read register dicitionary
---

zigbee_AT = {}
zigbee_AT_ctl = {}





--
--
-- Special commands
-- Note format is used to determine how to generate send AT
--   and parse the Receive AT Messages
-- List of format commands
--    n -- no parameters
--    b -- byte parameter
--    s -- short parameter
--    i -- integer 32 bit parameter
--    l -- long 64 bit parameter
--    k -- 128 bit DES key
--    t -- node identifier ( up to 20 bytes)
--    d -- node discovery reply
--           network address              2 bytes
--           destination address          1 byte
--           network identifier string    0 terminated
--           parent network address       2 bytes
--           device type                  2 bytes
--           status                       1 byte
--           profile Id                   2 bytes
--           manufacture id               2 bytes
--
--     h -- DN Message  -- note in transmit h is the same as t
--             network address     2 bytes
--             destination address 8 bytes
--
--    
--
--
--
--
--





zigbee_AT.WR = { format="n",  type = "w" }   -- write nonvolatile
zigbee_AT.RE = { format="n", type = "w" }   -- retore defaults
zigbee_AT.FR = { format="n", type = "w" }   -- software reset
zigbee_AT.NR = { format="b", type = "w" }   -- network reset

--
--
-- Addressing Commands
--
--

zigbee_AT.MY = { format='s',value = 0 } -- Network Address
zigbee_AT.MP = { format='s',value = 0 } -- Parent Network Address
zigbee_AT.NC = { format='b',value = 0 } -- Number Remaining Children
zigbee_AT.SH = { format='i',value = 0,type="r" } -- Serial Number High
zigbee_AT.SL= { format='i',value = 0,type="r" }  -- Serial Number Low
zigbee_AT.NI= { format='t',value = 0 } -- Node identifier
zigbee_AT.DD= { format='i',value = 0, type ="r" } -- device type
zigbee_AT.SE= { format='b',value = 0 } -- source end point
zigbee_AT.DE= { format='b',value = 0 } -- source destination
zigbee_AT.CI= { format="s",value = 0,   } -- Clustr Identifier 
zigbee_AT.NP = { format="s",value = 0, type="r" } -- Max RF Payload

---
---
--- Networking Commands
---
---
---
zigbee_AT.CH = { format="b",value = 0, type="r" } 
zigbee_AT.EI= { format="l", value = 0 } -- 
zigbee_AT.OE= { format="l", value = 0, type="r" } -- 
zigbee_AT.NH= { format="b", value = 0 } -- 
zigbee_AT.BH= { format="b", value = 0 } -- 
zigbee_AT.OP= { format="s", value = 0, type="r" } -- 
zigbee_AT.NT= { format="s", value = 0 } -- 
zigbee_AT.NO= { format="b", value = 0 } -- 
zigbee_AT.ND= { format="d", value = 0 } -- 
zigbee_AT.DN= { format="h", value = 0 } -- 
zigbee_AT.SC= { format="s", value = 0 } -- 
zigbee_AT.SD= { format="b", value = 0 } -- 
zigbee_AT.ZS= { format="b", value = 0 } -- 
zigbee_AT.NJ= { format="b", value = 0 } -- 
zigbee_AT.JV= { format="b", value = 0 } -- 
zigbee_AT.JN= { format="b", value = 0 } -- 
zigbee_AT.AR= { format="b", value = 0 } -- 
zigbee_AT.AI= { format="b", value = 0 , type = "r" } -- 

--
--
-- Security
--
--
zigbee_AT.EE= { format="b", value = 0 } -- 
zigbee_AT.EO= { format="b", value = 0  } -- 
zigbee_AT.KY= { format="k", value = 0, type="w" } -- 
zigbee_AT.KK= { format="k", value = 0, type="w" } -- 

---
---
--- RF Interfacing
---
---
zigbee_AT.PL= { format="b", value = 0 } -- 
zigbee_AT.PM= { format="b", value = 0 } -- 
zigbee_AT.DB= { format="b", value = 0 } -- 
zigbee_AT.AP= { format="b", value = 0 } -- 
zigbee_AT.AO= { format="b", value = 0 } -- 
zigbee_AT.BO= { format="b", value = 0 } -- 
zigbee_AT.NB= { format="b", value = 0 } -- 
zigbee_AT.RO= { format="b", value = 0 } -- 
zigbee_AT.D7= { format="b", value = 0 } -- 
zigbee_AT.D6= { format="b", value = 0 } -- 

---
--- I/O COMMANDS
---
---
---
zigbee_AT.IS= { format="n",type="w" } -- Force Sample
zigbee_AT["1S"]= { format="s",value = 0  } -- XBEE Sensor Sample
zigbee_AT.IR= { format="s",value = 0  } -- I/O Sample Rate
zigbee_AT.IC= { format="b",value = 0  } -- Digital Change Detection
zigbee_AT.P0= { format="b",value = 0  } -- PWM0 Configuration
zigbee_AT.P1= { format="b",value = 0 } -- DIO11 Configuration
zigbee_AT.P2= { format="b",value = 0 } -- DIO12 Configuration
zigbee_AT.P3= { format="b",value = 0 } -- DIO13 Configuration
zigbee_AT.D0= { format="b",value = 0 } -- DIO9 Configuration
zigbee_AT.D1= { format="b",value = 0 } -- DIO1 Configuration
zigbee_AT.D2= { format="b",value = 0 } -- DIO2 Configuration
zigbee_AT.D3= { format="b",value = 0 } -- DIO3 Configuration
zigbee_AT.D4= { format="b",value = 0 } -- DIO4 Configuration
zigbee_AT.D5= { format="b",value = 0 } -- DIO5 Configuration
zigbee_AT.LT= { format="b",value = 0 } -- Assoc LED Blink Time
zigbee_AT.D8= { format="b",value = 0 } -- DIO8 Configuration 
zigbee_AT.PR= { format="s",value = 0 } -- Pull up Registers
zigbee_AT.RP= { format="b",value = 0 } -- RSSI PWM Timer
zigbee_AT.CB= { format="b",type="w" } -- Commissioning Pushbutton

---
--- Diagnostics
---

zigbee_AT.VR = { format="s",value = 0, type="r" } -- Firmware Version
zigbee_AT.HR = { format="s",value = 0, type="r" } -- Hardware Version
zigbee_AT["%V"] = { format="s",value = 0, type="r" } -- supply Voltage 

function zigbee_AT_ctl.getFormat( register)
  local temp, returnValue
  temp = zigbee_AT[ register ]
  if temp ~= nil then
    returnValue = temp.format
  else
    returnValue = nil
  end
  return returnValue
end


function zigbee_AT_ctl.build_AT_db()

  local returnValue
  local i,j

  returnValue = {}
  for i,j in pairs( zigbee_AT ) do
    returnValue[i] = {}
    returnValue[i].value = true
  end
  returnValue["ND"].value = {} -- this is the dictionary of attached devices
  return returnValue
end







--
--
-- Note value2 is used for only for 64 bit registers
--
--

function zigbee_AT_ctl.set( handle, register, value1, value2 )
  local temp
  local returnValue
  if zigbee_AT[ register ] == nil then return nil end
 temp = zigbee_AT[ register ]
  if temp.type ~= nil then
    if temp.type == 'r' then
     return nil
    end
  end
 
  if temp.format ~= "n" then
    returnValue =zigbee_api_tx.txAT( handle, register, temp.format, value1, value2 )
  else
   returnValue = zigbee_api_tx.txAT( handle, register )
  end
  return returnValue
end

function zigbee_AT_ctl.read( handle, register )
  local temp
  -- check for support 
  if zigbee_AT[ register ] == nil then return nil end
  temp = zigbee_AT[ register ]
  if temp.type ~= nil then
    if temp.type == 'w' then
     return nil
    end
  end
  
  return zigbee_api_tx.txAT( handle, register  )
end   

function zigbee_AT_ctl.parseAT( AT_db, message )
  local rxFrame, command, status, data, format, value1, value2
  local temp
  local NA,DAH,DAL,NI,PA,DT,ST,PI,MI
  local eventData

  eventData = {}

  rxFrame , command, status, data = zigbee_api_parse.ATResponse( message )
  eventData.frame = rxFrame
  eventData.register = command
  status = tonumber(status)
  if status ~= 0 then return end 
  if zigbee_AT[ command ] ~= nil then 
    format = zigbee_AT[ command].format
    if command ==  "DN" then
      AT_db[command].value = {}
      NA,DAH,DAL = zigbee_api_parse.ATData( format,data )
      AT_db[command].value.na = NA
      AT_db[command].value.dah = DAH
      AT_db[command].value.dal = DAL
      print("DN",NA,DAH,DAL )
      publishSubscribe.post( masterEventList.zigBeeEvent.atCommand  ,eventData )
    elseif command == "ND" then
      NA,DAH,DAL,NI,PA,DT,ST,PI,MI = zigbee_api_parse.ATData( format, data )
      print("ND data NA,DAH,DAL,NI,PA,DT,ST,PI,MI",NA,DAH,DAL,NI,PA,DT,ST,PI,MI 
)
      temp = {}
      temp.na = NA  -- network address
      temp.dah = DAH  -- destination address high
      temp.dal = DAL  -- destination address low
      temp.ni = NI  -- network identifier
      temp.pa = PA  -- parent network address
      temp.dt = DT  -- device type
      temp.st = ST  -- status
      temp.pi = PI  -- profile Id
      temp.mi = MI  -- manufacture id
      AT_db[command].value[NI] = temp
      publishSubscribe.post( masterEventList.zigBeeEvent.atCommand, eventData )
    else
      AT_db[command].value = {}
      value1, value2 = zigbee_api_parse.ATData( format,data )
      AT_db[command].value.value1 = value1
      AT_db[command].value.value2 = value2
      publishSubscribe.post( masterEventList.zigBeeEvent.atCommand, eventData )       
    end
  else
    print("unsupported AT command ",command )
  end
end 

function zigbee_AT_ctl.parseRemoteAT( command , data)
  local value1, value2
  if zigbee_AT[ command ] ~= nil then 
    format = zigbee_AT[ command].format
    if command ==  "DN" then
      value1 = nil;
      value2 = nil;
    elseif command == "ND" then
      value1 = nil;
      value2 = nil;
    else
   
      value1, value2 = zigbee_api_parse.ATData( format,data )
             
    end
  else
    value1 = nil
    value2 = nil
    print("unsupported AT command ",command )
  end
  return value1,value2
end 


function zigbee_AT_ctl.help()
 print("commands for zigbee_AT ")
 print(".set( register, value ) -- set a register value")
 print(".read( register ) -- reads a register value")
 print(".parseAt(AT_table,inputMessage) -- parse AT message") 
 print(".parseRemoteAt( command data) -- parse Remote AT data part") 

end
 
