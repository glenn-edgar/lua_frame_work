---
---
---  These routines provide message filtering and 
---  event callback services
---
---
---




---
---
--- This object provide support for modem status messages
---
---
---
---
---



zigbeeModemStatusCb = {}
zigbeeModemStatusCb.queue = {}


function zigbeeModemStatusCb.constructor()
   eventSystem.allocateQueue( "zigbeeModemStatusCb", zigbeeModemStatusCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.modemStatus  ,"zigbeeModemStatusCb" )
end


function zigbeeModemStatusCb.destructor()
  eventSystem.removeQueue( "zigbeeModemStatusCb" )
  publishSubscribe.remove( masterEventList.zigBeeEvent.modemStatus , "zigbeeModemStatusCb" )
end


function zigbeeModemStatusCb.queueEvent(  queue, event )
  local temp 
  temp = {}
  temp.queue = queue
  temp.event = event
  table.insert( zigbeeModemStatusCb.queue , temp )
end

function zigbeeModemStatusCb.removeEvent( queue)
 local temp
 temp = zigbeeModemStatusCb.queue
 zigbeeModemStatusCb.queue = {}
 for i,j in ipairs( temp ) do
  if j.queue == queue then
     -- do nothing which will remove entry

   else
      zigbeeRxAtCb.queue[i] = j
   end
 end
end




function zigbeeModemStatusCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.modemStatus then return end
 temp = zigbeeModemStatusCb.queue
 for i,j in ipairs( temp ) do
      eventSystem.queue( j.queue, j.event, data )
 end
end





---
--- This object provides support for AT message CallBack
---
---
zigbeeRxAtCb = {}
zigbeeRxAtCb.queue = {} -- queue of filtered messages

function zigbeeRxAtCb.constructor()
   eventSystem.allocateQueue( "zigbeeRxAtCb", zigbeeRxAtCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.atCommand ,"zigbeeRxAtCb" )
end


function zigbeeRxAtCb.destructor()
  eventSystem.removeQueue( "zigbeeRxAtCb" )
  publishSubscribe.remove( masterEventList.zigBeeEvent.atCommand , "zigbeeRxAtCb" )
end


function zigbeeRxAtCb.queueEvent( frameId, register, queue, event )
  local temp 
  temp = {}
  temp.frame = frameId
  temp.register = register
  temp.queue    = queue
  temp.event    = event
  table.insert( zigbeeRxAtCb.queue , temp )
end

function zigbeeRxAtCb.removeEvent( frameId, register)
 local temp
 temp = zigbeeRxAtCb.queue
 zigbeeRxAtCb.queue = {}
 for i,j in ipairs( temp ) do
  if ( j.frame == frameId ) and (  j.register == register ) then
     -- do nothing which will remove entry

   else
      zigbeeRxAtCb.queue[i] = j
   end
 end
end




function zigbeeRxAtCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.atCommand then return end
 temp = zigbeeRxAtCb.queue
 zigbeeRxAtCb.queue = {}
 for i,j in ipairs( temp ) do
  if ( j.frame == data.frame ) and ( j.register == data.register ) then
      eventSystem.queue( j.queue, j.event,nil)
   else
      zigbeeRxAtCb.queue[i] = j
   end
 end
end


---
---
--- This object provides support for TX message status
---
---
zigbeeTxStatusCb = {}
zigbeeTxStatusCb.queue = {}

function zigbeeTxStatusCb.constructor()
   eventSystem.allocateQueue( "zigbeeTxStatusCb", zigbeeTxStatusCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.txStatus ,"zigbeeTxStatusCb" )
end


function zigbeeTxStatusCb.destructor()
  eventSystem.removeQueue( "zigbeeTxStatusCb" )
  publishSubscribe.remove( masterEventList.zigBeeEvent.txStatus , "zigbeeTxStatusCb" )
end


function zigbeeTxStatusCb.queueEvent( frameId , queue, event )
  local temp 
  temp = {}
  temp.frame = frameId
  temp.queue    = queue
  temp.event    = event
  table.insert( zibeeTxStatusCb.queue , temp )
end

function zigbeeTxStatusCb.removeEvent( frameId )
 local temp
 temp = zigbeeTxStatusCb.queue
 zigbeeTxStatusCb.queue = {}
 for i,j in ipairs( temp ) do
  if  j.frame == frameId  then
     -- do nothing which will remove entry

   else
      zigbeeTxStatusCb.queue[i] = j
   end
 end
end




function zigbeeTxStatusCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.txStatus then return end
 temp = zigbeeTxStatusCb.queue
 zigbeeTxStatusCb.queue = {}
 for i,j in ipairs( temp ) do
  if ( j.frame == data.frame )  then
      eventSystem.queue( j.queue, j.event, data)
   else
      zigbeeTxStatusCb.queue[i] = j
   end
 end
end












---
--- This object provides support for Remote AT message CallBack
---
---



zigbeeRemoteRxAtCb = {}
zigbeeRemoteRxAtCb.queue = {} -- queue of filtered messages

function zigbeeRemoteRxAtCb.constructor()
   eventSystem.allocateQueue( "zigbeeRemoteRxAtCb", zigbeeRxAtCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.remoteAtCommand ,"zigbeeRemoteRxAtCb" )
end


function zigbeeRemoteRxAtCb.destructor()
  eventSystem.removeQueue( "zigbeeRemoteRxAtCb" )
  publishSubscribe.remove( masterEventList.zigBeeEvent.remoteAtCommand , "zigbeeRemoteRxAtCb" )
end


function zigbeeRemoteRxAtCb.removeEvent( da_h,da_l, register)
 local temp
 temp = zigbeeRemoteRxAtCb.queue
 zigbeeRemoteRxAtCb.queue = {}
 for i,j in ipairs( temp ) do
  if ( j.da_h == da_h ) and (j.da_l == da_l) and (  j.register == register ) then
     -- do nothing which will remove entry

   else
     zigbeeRemoteRxAtCb.queue[i] = j
   end
 end
end



function zigbeeRemoteRxAtCb.queueEvent( da_h,da_l, register, queue, event )
  local temp 
  temp = {}
  temp.da_h        = da_h
  temp.da_k        = da_l
  temp.register    = register
  temp.queue       = queue
  temp.event       = event
  table.insert( zigbeeRemoteRxAtCb.queue , temp )
end

function zigbeeRemoteRxAtCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.remoteAtCommand  then return end
 temp = zigbeeRemoteRxAtCb.queue
 zigbeeRemoteRxAtCb.queue = {}
 for i,j in ipairs( temp ) do
  if (j.da_h == data.da_h) and ( j.da_l == data.da_l ) and ( j.register == data.register ) then
      eventSystem.queue( j.queue,j.event,data.register)
  else
      zigbeeRemoteRxAtCb.queue[i] = j
  end
 end
end
  
zigbeeNodeIdCb = {}
zigbeeNodeIdCb.queue = {}

function zigbeeNodeIdCb.constructor()
   eventSystem.allocateQueue( "zigbeeNodeIdCb", zigbeeRxAtCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.nodeId ,"zigbeeNodeIdCb" )
end


function zigbeeNodeIdCb.destructor()
  eventSystem.removeQueue( "zigbeeNodeIdCb" )
  publishSubscribe.remove( masterEventList.zigBeeEvent.nodeId , "zigbeeNodeIdCb" )
end


function zigbeeNodeIdCb.removeEvent( queue )
 local temp
 temp = zigbeeNodeIdCb.queue
 zigbeeNodeIdCb.queue = {}
 for i,j in ipairs( temp ) do
  if   j.queue == queue then
     -- do nothing which will remove entry
   else
     zigbeeNodeIdCb.queue[i] = j
   end
 end
end



function zigbeeNodeIdCb.queueEvent( queue, event )
  local temp 
  temp = {}
  temp.queue       = queue
  temp.event       = event
  table.insert( zigbeeNodeIdCb.queue , temp )
end

function  zigbeeNodeIdCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.nodeId  then return end
 temp = zigbeeNodeIdCb.queue

 for i,j in ipairs( temp ) do
   eventSystem.queue( j.queue,j.event,data)
 end
end



zigbeeRxPacketCb = {}
zigbeeRxPacketCb.queue = {}
function zigbeeRxPacketCb.constructor()
   eventSystem.allocateQueue( "zigbeeRxPacketCb", zigbeeRxAtCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.rxPacket ,"zigbeeRxPacketCb" )
end


function zigbeeRxPacketCb.destructor()
  eventSystem.removeQueue( "zigbeeRxPacketCb" )
  publishSubscribe.remove( masterEventList.zigBeeEvent.rxPacket , "zigbeeRxPacketCb" )
end


function zigbeeRxPacketCb.removeEvent( da_h,da_l, queue )
 local temp
 temp = zigbeeRxPacketCb.queue
 zigbeeRxPacketCb.queue = {}
 for i,j in ipairs( temp ) do
  if ( j.da_h == da_h ) and (j.da_l == da_l) and (  j.queue == queue ) then
     -- do nothing which will remove entry

   else
      zigbeeRxPacketCb.queue[i] = j
   end
 end
end



function zigbeeRxPacketCb.queueEvent( da_h,da_l, queue, event )
  local temp 
  temp = {}
  temp.da_h        = da_h
  temp.da_l        = da_l
  temp.queue       = queue
  temp.event       = event
  table.insert( zigbeeRxPacketCb.queue , temp )
end

function zigbeeRxPacketCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.rxPacket  then return end
 temp = zigbeeRxPacketCb.queue
 for i,j in ipairs( temp ) do
  if (j.da_h == data.da_h) and ( j.da_l == data.da_l ) then
      eventSystem.queue( j.queue,j.event,data)
  end
 end
end
  


zigbeeExplicitRxCb = {}
zigbeeExplicitRxCb.queue = {}

function zigbeeExplicitRxCb.constructor()
   eventSystem.allocateQueue( "zigbeeExplicitRxCb", zigbeeExplicitRxCb.process )
   publishSubscribe.attach(masterEventList.zigBeeEvent.explictRx ,"zigbeeExplicitRxCb" )
end


function zigbeeExplicitRxCb.destructor()
  eventSystem.removeQueue( "zigbeeExplicitRxCb" )
  publishSubscribe.remove( masterEventList.zibBeeEvent.explicitRx , "zigbeeExplicitRxCb" )
end


function zigbeeExplicitRxCb.removeEvent( profile, queue )
 local temp
 temp = zigbeeExplicitRxCb.queue
 zigbeeExplicitRxCb.queue = {}
 for i,j in ipairs( temp ) do
  if (j.profile == profile ) and (j.queue == queue )  then
     -- do nothing which will remove entry
   else
      zigbeeRxPacketCb.queue[i] = j
   end
 end
end



function zigbeeExplicitRxCb.queueEvent( profile, queue, event )
  local temp 
  temp = {}
  temp.profile     = profile
  temp.queue       = queue
  temp.event       = event
  table.insert( zigbeeExplicitRxCb.queue , temp )
end

function zigbeeExplicitRxCb.process(event, data)
 local temp
 
 if event ~= masterEventList.zigBeeEvent.explicitRx  then return end
 temp = zigbeeExplicitRxCb.queue
 for i,j in ipairs( temp ) do
  if j.profile == data.profile then
      eventSystem.queue( j.queue,j.event,data)
  end
 end
end
  


zigbeeDeviceManager = {}
zigbeeDeviceManager.registeredDevices = {}
zigbeeDeviceManager.unexpectedDevices = {}
function zigbeeDeviceManager.addDevice( da_h,da_l,nodeId)
end

function zigbeeDeviceManager.removeDevice( da_h,da_l, modeId )
end

function zigbeeDeviceManager.getRegisterDevices()
end

function zigbeeDeviceManager.getUnexpectedDevices()
end

function zigbeeDeviceManager.addContact( da_h,da_l, nodeId )
end






