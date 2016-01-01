----
----
---- tod thread
----
----


-- masterEventList.todSec    = 200  -- data is the second
-- masterEventList.todMinute = 201  -- data is the minute
-- masterEventList.todHour   = 202  -- data is the hour
-- masterEventList.todDay    = 203  -- data is the day
-- masterEventList.todAdd    = 204  -- data is list with following parameters
                                 -- { tod_key, time (sec), max time (sec) ,
                                 --   event}
-- masterEventList.todRemove = 205  -- data is unique id

tod = {}

local tod.queue = {}

function tod.processTodEntry( i, j )
  local currentTime
  
  currentTime = os.time()
  if currentTime >= j.setTime then
   if currentTime <= j.maxTime then
    eventSytem.queueEvent( j.queue,j.event, j.data )
    tod.queue[i] = nil
   end
  end

end


function tod.processTodQueue()
 local i,j
 for i,j in pairs( todQueue ) do
   processTodEntry(i,j)
 end
end

function tod.addTodEntry(  todQueue, queue, setTime, maxTime, event,data )
 local temp
 temp = {}
 temp.setTime    =   setTime
 temp.maxTime =    maxTime
 temp.queue       =    queueName
 temp.event         =   event
 temp.data           =   data
 tod.queue[ todQueue ] = temp
 temp = nil
end


function tod.removeTodEntry( todQueue )
  tod.queue[  todQueue ] = nil
end






function tod.todThread( event, data)
 if event == masterEventList.todSec then
   tod.processTodQueue()
 end
end

function tod.description()
  return "this package implements time of day functions"
end

function tod.help()
  print(".addTodEntry(  todQueue, queue, setTime, maxTime, event,data )  -- adds element to tod queue")
  print(".removeTodEntry( todQueue ) -- removes element from tod queue ")
end


eventSystem.allocateQueue("tod", todThread)
publishSubscribe.attach( masterEventList.todSec ,"tod") 





 

