---
--- File: event.lua
--- Lua Event System
---
---
---

eventSystem = {}

eventSystem.eventQueue = {}

function eventSystem.init()
   --- null function right now
end

function eventSystem.allocateQueue( queueName, appFunction )
    local temp
    temp = {}
    temp.appFunction = appFunction
    temp.queue    = {}
    temp.name     = queueName
    eventSystem.eventQueue[ queueName ] = temp
end

function eventSystem.removeQueue( queueName )
  eventSystem.eventQueue[ queueName ] = nil
end


function eventSystem.listQueues()
  local i,j
  print("List of Allocated Queues")
  for i,j in pairs( eventSystem.eventQueue) do
    print("Queue  ",i)
  end
end 



function eventSystem.flush( queueName )
  if eventSystem.eventQueue[ queueName ] ~= nil then
     eventSystem.eventQueue[queueName].queue = {}
  end
end

function eventSystem.queued( queueName )
  local returnValue
  local temp
  if eventSystem.eventQueue[ queueName ] ~= nil then
     temp = eventSystem.eventQueue[ temp ].queue
     returnValue = #( temp )
  else
     returnValue = 0
  end
  return returnValue
end

function eventSystem.queue( queueName,event, data )
  local temp
  local eventData

    eventData = { }
   eventData.queueName = queueName
   eventData.event              = event
   eventData.data                =  data
   
  if eventSystem.eventQueue[ queueName ] ~= nil then
    temp = eventSystem.eventQueue[ queueName].queue
    table.insert(temp,eventData)
  end
 
end

function eventSystem.queueCB( queueName,event, data )
  local temp
  local eventData


  eventData = { }
   eventData.queueName = queueName
   eventData.event              = event
   eventData.data                =  data
  if eventSystem.eventQueue[ queueName ] ~= nil then
    temp = eventSystem.eventQueue[ queueName].queue
    table.insert(temp,1, eventData)
  end
 
end


function eventSystem.dump( queueName )
   local temp
   local i
   local k

   
   if eventSystem.eventQueue[ queueName ] ~= nil then
     temp = eventSystem.eventQueue[ queueName ].queue
     printf("dumping queue ",queueName)
     for i,k in pairs(temp) do
       print("event",k.event,"data",k.data)
     end
  end
end



    
function eventSystem.processQueue()
  local i,j
  local returnValue
  local temp
  
  returnValue = 0
  
  for i,j in pairs( eventSystem.eventQueue ) do
    temp = j.queue
    if #(temp) ~= 0 then
      returnValue = returnValue + 1
      temp1 = table.remove(temp,1)
      temp.appFunction( temp1)
    end
  end
  return returnValue
end  

function eventSystem.sendToAllQueues( event, data )
  local i,j
  for i,j in pairs( eventSystem.eventQueue ) do
    eventSystem.queueCB( i, event,data)
  end

end  



local function help()
  print(".init( queueNumber)           initialize event system ")
  print(".flush( queue )               flushes event queue ")
  print(".queued( queue )              returns number queued")
  print(".queue( queue, event,data )   queues an event")
  print(".dump( queue)                 dumps contents of a queue ")
  print(".allocateQueue( queue, appFunction)        allocates a queue ")
  print(".removeQueue( queue )         removes a queue ")
  print(".listQueues()                 displays allocated queues ")
  print(".processQueue()               process events in event queue")
  print("                              -- returns 1 if events found 0 if no events found")
  print(".sendToAllQueues( event,data) sends an event to all queues ")  
  print(".help()                       displays commands ")
end


 






 


