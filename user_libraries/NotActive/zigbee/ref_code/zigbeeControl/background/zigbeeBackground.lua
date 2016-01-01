--
--
--
-- File: zigBee_controller.lua
-- This file implements the control aspects for a zigbee controller 
--
--
--
zigbeeBackground = {}

function zigbeeBackground.constructor(  ttyDevice )
  
   print("starting zigbee device")
   zigbeeControl.handle = zigbee.open(ttyDevice,3)  -- 57 Kbits serial link
   assert( zigbeeControl.handle > 0,"zigbee device"..ttyDevice .." did not open")

   zigbeeRxAtCb.constructor()
   zigbeeBackground.constructMessageParser( "zigbeeBackground".."_parser", "zigbeeBackground".."_parser"  )
   zigbeeBackground.deviceCheck.constructDeviceCheck( "zigbeeBackGround".."_deviceCheck", "zigbeeBackGround".."_deviceCheck")
  
end

function zigbeeBackground.destructor( )
      CF.removeChain(  "zigbeeBackground".."_parser" , "zigbeeBackground".."_parser" )
      zigbeeRxAtCb.destructor()

      CF.removeChain(  "zigbeeBackground".."_device_alive" , "zigbeeBackground".."_device_poller" )
      zigbee.close( zigbeeControl.handle )
      zigbeeControl.handle = nil
end

function zigbeeBackground.constructMessageParser( queue, name )

    local chainNode

   
    chainNode = CF.createChain( name )
    
    chainNode.locals.pollTime = 1
    --CF.addNode( chainNode, CFF.debug, {"waiting to parse messages" } )
    CF.addNode( chainNode, CFF.tick, { "pollTime" } )
    CF.addNode( chainNode, CFF.oneShot, { zigbeeControl.parseMessage, {nil} } )
    --CF.addNode( chainNode, CFF.debug, {"resetting chain " } )
    CF.addNode( chainNode, CFF.reset )
    CF.attachChain( chainNode, queue ) -- attach top level command

end

zigbeeBackground.deviceCheck = {}

zigbeeBackground.deviceCheck.checkDeviceEvent = 0xf0001
zigbeeBackground.deviceCheck.checkDeviceSuccess = 0
zigbeeBackground.deviceCheck.checkDeviceFailure = 0
zigbeeBackground.deviceCheck.conseqFailure = 0
zigbeeBackground.deviceCheck.deviceFailure = true
zigbeeBackground.deviceCheck.frameId = 0
zigbeeBackground.deviceCheck.register = "AI"

function zigbeeBackground.deviceCheck.constructDeviceCheck( queue, name )

    local chainNode

    zigbeeBackground.deviceCheck.checkDeviceEvent = 0xf0001
    zigbeeBackground.deviceCheck.checkDeviceSuccess = 0
    zigbeeBackground.deviceCheck.checkDeviceFailure = 0
    zigbeeBackground.deviceCheck.conseqFailure = 0
    zigbeeBackground.deviceCheck.deviceFailure = true

    chainNode = CF.createChain( name )
    
    chainNode.locals.pollTime = 5 -- five seconds
    CF.addNode( chainNode, CFF.delay, { "pollTime" } )
    CF.addNode( chainNode, CFF.oneShot, { zigbeeBackground.deviceCheck.checkDevice, {nil} } )
    CF.addNode( chainNode, 
                CFF.waitUntilEvent, 
                { 3 ,zigbeeBackground.deviceCheck.checkDeviceEvent,zigbeeBackground.deviceCheck.deviceFail, zigbeeBackground.deviceCheck.devicePass })
    CF.addNode( chainNode, CFF.reset )
    CF.attachChain( chainNode, queue ) -- attach top level command

end


function zigbeeBackground.deviceCheck.checkDevice()
  local frameId
  -- need to get the queue
  frameId = zigbeeControl.readAT("AI")

  zigbeeBackground.deviceCheck.frameId = frameId
  zigbeeBackground.deviceCheck.register = "AI"
  zigbeeRxAtCb.queueEvent( frameId, "AI", "zigbeeBackGround".."_deviceCheck", zigbeeBackground.deviceCheck.checkDeviceEvent ) 
end

function zigbeeBackground.deviceCheck.deviceFail()

  print(zigbeeBackground.deviceCheck.deviceStatus())
   zigbeeRxAtCb.removeEvent(  zigbeeBackground.deviceCheck.frameId,
                             zigbeeBackground.deviceCheck.register )

  zigbeeBackground.deviceCheck.checkDeviceFailure = zigbeeBackground.deviceCheck.checkDeviceFailure+1
  zigbeeBackground.deviceCheck.conseqFailure = zigbeeBackground.deviceCheck.conseqFailure + 1
  if (zigbeeBackground.deviceCheck.conseqFailure > zigbeeBackground.deviceCheck.conseqFailure ) and ( zigbeeBackground.deviceCheck.deviceFailure == false ) then
     zigbeeBackground.deviceCheck.deviceFailure = true
     publishSubscribe.post( masterEventList.zigBeeEvent.deviceFailure, nil )
  end
end

function zigbeeBackground.deviceCheck.devicePass()
  print(zigbeeBackground.deviceCheck.deviceStatus())
  zigbeeBackground.deviceCheck.conseqFailure = 0
  zigbeeBackground.deviceCheck.checkDeviceSuccess = zigbeeBackground.deviceCheck.checkDeviceSuccess +1
  zigbeeBackground.deviceCheck.deviceFailure = false
  publishSubscribe.post( masterEventList.zigBeeEvent.devicePass , nil )
end

function zigbeeBackground.deviceCheck.deviceStatus()
  return zigbeeBackground.deviceCheck.checkDeviceSuccess, 
         zigbeeBackground.deviceCheck.checkDeviceFailure, 
         zigbeeBackground.deviceCheck.deviceFailure
end


print("module zigbeeBackground is loaded")
  
