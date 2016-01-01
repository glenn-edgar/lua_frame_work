---
--- file: zigbeeControl.lua
---

zigbeeControl = {}
zigbeeControl.parseControl = {}
zigbeeControl.modemStatus = {}
zigbeeControl.modemStatus[0] =  "hardware reset"
zigbeeControl.modemStatus[1] =  "watchdog timer reset"
zigbeeControl.modemStatus[2] =  "associated"
zigbeeControl.modemStatus[3] =  "disassociated"
zigbeeControl.modemStatus[4] =  "Synchronization lost"
zigbeeControl.modemStatus[5] =  "Coordinator realignment"
zigbeeControl.modemStatus[6] =  "Coordinator started"

zigbeeControl.txStatus = {}
zigbeeControl.txStatus.frameId = false
zigbeeControl.txStatus.networkAddress = false
zigbeeControl.txStatus.txRetry = false
zigbeeControl.txStatus.delivery = false
zigbeeControl.txStatus.discovery = false
--
--- defining helper functions
---

function zigbeeControl.parseTxStatus( dummy ,message)
  local frameId, networkAddress,txRetry, delivery,discovery

  frameId, networkAddress,txRetry, delivery,discovery =
    zigbee_api_parse.txStatus( message )

  zigbeeControl.txStatus.frameId = frameId
  zigbeeControl.txStatus.networkAddress = networkAddress
  zigbeeControl.txStatus.txRetry = txRetry
  zigbeeControl.txStatus.delivery = delivery
  zigbeeControl.txStatus.discovery = discovery
  publishSubscribe.post( masterEventList.zigBeeEvent.txStatus, nil )
  print(frameId,networkAddress,txRetry,delivery,discovery )
end

function zigbeeControl.parseModemStatus( dummy, message )
  local register, valid
  valid, register = zigbee_api_parse.modemStatus( message )
  if valid ~= true then print("invalid modem status message") return end
  print(zigbeeControl.modemStatus[ register])
  publishSubscribe.post( masterEventList.zigBeeEvent.modemStatus , register )
end

function zigbeeControl.parseNodeId( dummy, message )
  local value
  local rem_h,rem_l,rna,option,da_h,da_l,dna,ni,pa,dt,action,pi,man_i
  rem_h,rem_l,rna,option,da_h,da_l,dna,ni,pa,dt,action,pi,man_i =
   zigbee_api_parse.nodeId( message)
  value = {}
  value.remote_high                 = rem_h
  value.remote_low                  = rem_l
  value.remote_network_address      = rna
  value.option                      = option
  value.destination_high            = da_h
  value.destination_low             = da_l
  value.destination_network_address = dna
  value.nodeId                      = ni
  value.parentAddress                = pa
  value.deviceType                   = dt
  value.sourceAction                 = action
  value.profileId                    = pi
  value.manufactoryId                = mi
  publishSubscribe.post( masterEventList.zigBeeEvent.nodeId, value )
end

         
function zigbeeControl.parseATRemoteResponse( dummy, message )
  local frame,da_h,da_l,na,command,data,value1,value2,format
  local temp

  value1 = nil
  value2 = nil
  frame,da_h,da_l,na,command,status,data =  zigbee_api_parse.ATRemoteResponse( message)
  if status == 0 then
   format = zigbee_AT_ctl.getFormat( command )
   if format ~= nil then
     value1, value2 = zigbee_api_parse.ATData( format,data )
   end
  end
  temp = {}
  temp.destination_high = da_h
  temp.destination_low  = da_l
  temp.networkAddress   = na
  temp.command          = command
  temp.status           = status
  temp.value1           = value1
  temp.value2           = value2  
  table_support.dump(temp)
  publishSubscribe.post(masterEventList.zigBeeEvent.remoteAtCommand , temp )
    
end

function zigbeeControl.parseRxMessage( dummy, message)
  local da_h,da_l,na,options,data
  local temp
  da_h,da_l, na, options,data = zigbee_api_parse.receivePacket(message)
  temp = {}
  temp.destinationHigh = da_h
  temp.destinationLow  = da_l
  temp.networkAddress  = na
  temp.options         = options
  temp.data            = data
  print(da_h,da_l,na,options,data)
  publishSubscribe.post(masterEventList.zigBeeEvent.rxPacket , temp )

end

function zigbeeControl.parseExplictRxMessage( dummy, message )
  local da_h,da_l,se,de,ci,pi,data
  local temp
  da_h,da_l,na,se,de,ci,pi,options,data = zigbee_api_parse.explicitRx(message)
  temp = {}
  temp.destination_high = da_h
  temp.destination_low  = da_l
  temp.networkAddress   = na
  temp.sourceEndPoint   = se
  temp.destinationEndPoint = de
  temp.clusterId           = ci
  temp.profile             = pi
  temp.options             = options
  temp.data                = data
  print("explicit rx",da_h,da_l,na,se,de,ci,pi,options,data)
  publishSubscribe.post(masterEventList.zigBeeEvent.explictRx, temp )
end

-- 0x88
zigbeeControl.parseControl[136] = {}
zigbeeControl.parseControl[136].parse = zigbee_AT_ctl.parseAT
-- 0x8a
zigbeeControl.parseControl[ 138] = {}
zigbeeControl.parseControl[138].parse = zigbeeControl.parseModemStatus

-- 0x8b
zigbeeControl.parseControl[139] = {}
zigbeeControl.parseControl[139].parse = zigbeeControl.parseTxStatus

-- 0x90
zigbeeControl.parseControl[144] = {}
zigbeeControl.parseControl[144].parse = zigbeeControl.parseRxMessage

-- 0x91
zigbeeControl.parseControl[145] = {}
zigbeeControl.parseControl[145].parse = zigbeeControl.parseExplictRxMessage

-- 0x95
zigbeeControl.parseControl[149] = {}
zigbeeControl.parseControl[149].parse = zigbeeControl.parseNodeId

-- 0x97
zigbeeControl.parseControl[151] = {}
zigbeeControl.parseControl[151].parse = zigbeeControl.parseATRemoteResponse



function zigbeeControl.parseMessage()
  local checkSum, messageId, message
  
 while  true do 
   checkSum, messageId, message =zigbee.getMessage( zigbeeControl.handle )
   if checkSum == nil then 
     --print("no messages found") 
     return 
   end
   if checkSum ~= 255 then
     print("bad checkSum", checkSum )
   elseif zigbeeControl.parseControl[ messageId ] == nil then
       print("unrecognized message",messageId)
   else
    zigbeeControl.parseControl[messageId].parse( zigbeeControl.AT_db,message)
   end
   
 end
end

---
--- AT Commands
---
---

function zigbeeControl.setAT( register,value1,value2 )
  return zigbee_AT_ctl.set( zigbeeControl.handle, register, value1, value2 )
end

function zigbeeControl.readAT( register )
  return zigbee_AT_ctl.read( zigbeeControl.handle, register )
end

function zigbeeControl.read_AT_DB( register )
  table_support.dump( zigbeeControl.AT_db[register] )
end


--
-- General TX commands
--
--

function zigbeeControl.readRemoteAT( destinationHigh,
                                     destinationLow,
                                     networkAddress,
                                     register )

local frameId

frameId =    zigbee_api_tx.txremoteAt( zigbeeControl.handle,
                              destinationHigh,
                              destinationLow,
                              networkAddress,
                              0, -- options
                              register )

return frameId

end

function zigbeeControl.setRemoteAT( destinationHigh,
                                    destinationLow,
                                    networkAddress,
                                    register,
                                    value1,
                                    value2 )
 local format
 local frameId
 
 format = zigbee_AT_ctl.getFormat( register)

 if format ~= nil then
  frameId = zigbee_api_tx.txremoteAt( zigbeeControl.handle,
                              destinationHigh,
                              destinationLow,
                              networkAddress,
                              0,
                              register,
                              format,
                              value1,
                              value2 )
 end
 
 return frameId
end


function zigbeeControl.sendTxPacket( destinationHigh,
                                     destinationLow,
                                     networkAddress,
                                     raduis,
                                     multicastFlag,
                                     data )
 local option,data1, frameId

  if multicastFlag ~= false then
    option = 0x8
  else
    option = 0
  end

 frameId = zigbee_api_tx.txPacket(zigbeeControl.handle,
                         destinationHigh,
                         destinationLow,
                         networkAddress,
                         raduis,
                         option,
                         data
                         ) 
  return frameId
 end

function zigbeeControl.sendExplicitTxPacket( destinationHigh,
                                             destinationLow,
                                             networkAddress,
                                             sourceEndPoint,
                                             destinationEndPoint,
                                             clusterId,
                                             profileId,
                                             broadCastRadius,
                                             data )

local frameId 
 frameId = zigbee_api_tx.txCommandFrame(  zigbeeControl.handle, 
                                          destinationHigh,
                                          destinationLow,
                                          networkAddress,
                                          sourceEndPoint, 
                                          destinationEndPoint,
                                          clusterId,
                                          profileId,
                                          broadCastRadius,
                                          data )
 return frameId
end


                                             

---

-- building AT_db
zigbeeControl.AT_db = zigbee_AT_ctl.build_AT_db()









