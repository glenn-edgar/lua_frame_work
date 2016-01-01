---
---
---  Garbage Collection Thread
---
---
function gcThread( event, data)
 if event == masterEventList.todMinute then
  -- print("executing garbage collection")
   lgc.collect()
  -- print("memory useage", lgc.count())
 end
 
end


eventSystem.allocateQueue("gc", gcThread)
publishSubscribe.attach( masterEventList.todMinute ,"gc") 


