---
--- File: publishSubscribe.lua
--- Lua Publish Subscribe.lua
---
---
---



publishSubscribe = {}


publishSubscribe.queue = {}

function publishSubscribe.initializePublishSubscribe()
   -- null function right now
end

function publishSubscribe.flush( event )
  publishSubscribe.queue[event] = {}
end

function publishSubscribe.number( event )
  local returnValue
  if publishSubscribe.queue[event] == nil then
   returnValue = 0
  else
   returnValue = #(publishSubscribe.queue[event])
  end
  return returnValue
end

function publishSubscribe.attach( event,queueId )
 local temp
  
  if publishSubscribe.queue[event] == nil then
    publishSubscribe.queue[event] = {}
  end
  temp = publishSubscribe.queue[event]
  temp[queueId] = 1
  
end

function publishSubscribe.remove( event, queueId )
  local temp
  
  if publishSubscribe.queue[event] ~= nil then
   temp = publishSubscribe.queue[event]
   temp[queueId] = nil
  end
  
end


function publishSubscribe.post( event, data )

  if publishSubscribe.queue[ event] ~= nil then
    for i,k in pairs( publishSubscribe.queue[event]) do
       eventSystem.queue(i,event,data)
    end
  end
end


function publishSubscribe.dump()
  
   printf("dumping Publish Subscribe Queue")
   for i,k in pairs(publishSubscribe.queue) do
    print("event",i)
   end
  
 
end


function publishSubscribe.dumpEventQueue( event )
  
 
   print("dumping Publish Subscribe Queue for event ", event)
   print("printing a list of queues")
   if publishSubscribe.queue[event] == nil then
    print("empty queue")
   else
     for i,k in pairs(publishSubscribe.queue[event]) do
       print("queue ",i)
     end
   end
  

end

function  publishSubscribe.description()
  return "publish and subscribe functionality")
end  

function publishSubscribe.help()
  print(".init                     .. initialize")
  print(".flush(event)             .. remove subscribers for a specific event")
  print(".number(event)            .. number of subscribers for an event")
  print(".attach(event, queue)     .. attach a queue to an event ")
  print(".remove(queue)            .. removes a queue attached to an event")
  print(".post(event,data)              .. post an event ")
  print(".dump()                   .. dump register events ")
  print(".dumpEventQueue( event )  .. dump queue registered to an event")
  print(".help()                   .. displays commands ")
end


 


