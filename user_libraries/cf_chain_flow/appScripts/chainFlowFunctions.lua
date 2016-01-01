--- 
--
--- Utilitiy functions for chain flow programming

---
---
--- Utility functions are associated with logic and control
---
---
--- tick                data [ timeTicks  ]
--- delay               data [ timeDelay -- seconds ]
--- waitUntil           data [ timeDelay, verifyfunction, failureFunction ]
--- waitUntilEvent      data [ timeDelay, event, failureFunction  ]
--- verfify             data [ samplingDelay, verifyfunction, failureFunction ]
--- oneShot             data [ function, ... function data ]
--- subChain            data [ subChain ]
--- whileChain          data [ testFunction, subChainName ]
--- caseChain           data [ choiceFunction, chain,.....chain] 
--- parallelChain       data [ chains ... chains]
--- changeState         data[ name, newState ]

cff = {}
--- tick -- data [ ticks  ]
function cff.tick( chainNode,data,queue, event, eventData )
  local returnValue

  returnValue = cf.halt 
  if event == cf.initEvent then
    data.tick = cf.filterParameter( chainNode, data[1] )
  end
  if event ==masterEventList.timeTick then
   
    data.tick = data.tick -1 
    if data.tick == 0 then
      returnValue = CF.continue 
      cf.deactivateNode( chainNode,nil )   
    end
  end
   
  
  return returnValue 
end


--- delay -- data [ timeDelay -- seconds ]
function cff.delay( chainNode,data,queue, event, eventData )
  local returnValue
  
  
  returnValue = cf.halt 
  if event == cf.initEvent then
    
    data.timeEntry = cf.filterParameter( chainNode, data[1] )
 
  end
  if event ==masterEventList.todSec then
    data.timeEntry = data.timeEntry -1
    if data.timeEntry == 0 then
      returnValue = cf.continue 
      cf.deactivateNode( chainNode,nil )   
           end

  end
  
  return returnValue 
end



--- waitUntil -- data [ timeDelay, verifyfunction, failureFunction  ]
function cff.waitUntil( chainNode, data,queue, event, eventData )
  local returnValue
  local verifyFunction
  local failureFunction
  local passFunction

  verifyFunction = data[2]
  failureFunction = data[3]
  passFunction = data[4]

  returnValue = cf.halt 

  if event == cf.initEvent then
    data.timeEntry = data[1]
  end

  if event ==masterEventList.todSec then
    data.timeEntry = data.timeEntry -1
    if verifyFunction( chainNode, data, queue, event, eventData) == true then
      if passFunction ~= nil then
        passFunction( chainNode, data, queue, event, eventData)
      end
      cf.deactivateNode( chainNode,nil )
      returnValue = cf.continue 
    else
     if data.timeEntry == 0 then 
       returnValue = failureFunction( chainNode, data, queue, event, eventData)
       cf.deactivateNode( chainNode,nil )
     end      
    end
  else
     -- else do nothing for other events
  end
  return returnValue 
end

--- waitUntilEvent -- data [ timeDelay, event, failureFunction  ]
function cff.waitUntilEvent( chainNode, data,queue, event, eventData )
  local returnValue
  local passEvent
  local failureFunction
  local passFunction
 
  passEvent = data[2]
  failureFunction = data[3]
  passFunction = data[4]

  returnValue = cf.halt 

  if event == cf.initEvent then
    data.timeEntry = data[1]
  end
 

  if event == passEvent then
      cf.deactivateNode( chainNode,nil )
      if passFunction ~= nil then
         passFunction( chainNode, data, queue, event, eventData)
      end
      returnValue = cf.continue 
  end
  
  if event ==masterEventList.todSec then
    data.timeEntry = data.timeEntry -1
    if data.timeEntry == 0 then 
       failureFunction( chainNode, data, queue, event, eventData)
       cf.deactivateNode( chainNode,nil )
         
    end
  else
     -- else do nothing for other events
  end
  return returnValue 
end



--- verify -- data [ verifyfunction, failureFunction ]
function cff.verify( chainNode, data, queue, event , eventData )
   local returnValue
   local verifyFunction
   local failureFunction
  
   verifyFunction = data[1]
   failureFunction = data[2]
  
   if verifyFunction( chainNode, data, queue, event, eventData ) == false then
      returnValue = failureFunction( chainNode, data, queue, event, eventData )
   else
      returnValue = cf.continue
   end
   return returnValue
end
    

--- oneShot  data [ function, [ function data .. ] ]
function cff.oneShot( chainNode, data, queue, event, eventData )
  local oneShotFunction
  if event == cf.initEvent then
     oneShotFunction = data[1]
     oneShotFunction( chainNode, data[2], queue, event , eventData )
     cf.deactivateNode( chainNode,  nil )
    end
  return cf.continue
end

--- cleanUp  data [ function, [ function data .. ] ]
function cff.chainFlowCleanUp( chainNode, data, queue, event, eventData )
  local cleanUpFunction
  if event == cf.termEvent then
     cleanUpFunction = data[1]
     cleanUpFunction( chainNode, data[2], queue, event , eventData )
     cf.deactivateNode( chainNode,  nil )
    end
  return cf.continue
end

--- subChain -- data [ subChain ]
function cff.subChain( chainNode, data, queue, event,eventData)

   local returnValue
   local chainNode_a
   local chainName
   
   chainName = data[1]
   
   returnValue = cf.continue
   chainNode_a = cf.findChain( chainName )  
   if chainNode_a ~= nil then
        if event == cf.termEvent then
           cf.resetChain( chainNode_a,queue,event,data )
        else 
           if event ~= cf.initEvent then
            returnValue = cf.processChain( chainNode_a, queue, event, eventData )
           end
        end 
   end
   return returnValue

end




--- caseChain -- data [ choiceFunction, [ chain,.....chain] ] 
function cff.caseChain( chainNode, data, queue, event, eventData )
   local number
   local caseIndex
   local returnValue  
   local chainName_a
   local chainNode_a 
   local temp

    returnValue = cf.continue
   -- find number choices
   number = table.maxn (data) -1
    -- calling function to make choice index
   caseIndex = data[1]( chainNode, data, queue, event, eventData )
   temp = data[2]
   chainName_a = temp[ caseIndex ]
   
   if chainName_a ~= nil then
     chainNode_a = cf.findChain( chainName_a )  
    
     if chainNode_a ~= nil then
        if event == cf.termEvent then
           cf.resetChain( chainNode_a,queue,event,data )
        else if event ~= cf.initEvent then
         returnValue = cf.processChain( chainNode_a, queue, event, eventData )
        end
        end
     end
   end
   return returnValue
end

--- whileChain data [ testFunction, subChainName ]
function cff.whileChain( chainNode, data, queue, event, eventData )

    local returnValue
    local testFunction
    local chainName
    local chainNode     

    returnValue = cf.continue
    testFunction = data[1]
    chainName    = data[2]
    chainNode = cf.findChain( chainName )
  
    if chainNode == nil then
      return cf.abort
    end
    if testFunction == nil then
      return cf.abort
    end
    if testFunction( chainNode,data,queue,event,eventData ) == true then   
       returnValue = cf.processChain( chainNode, queue, event, eventData )
       if returnValue == cf.exitLoop then
          returnValue = cf.continue
       end
       if returnValue == cff.continueLoop then
          returnValue = cff.halt
       end
    else
       returnValue = cff.continue
    end

    return returnValue
end 


--- parallelChain data [ chains ... chains]
function cff.parallelChain( chainNode, data,queue, event, eventData )
   local number
   local chainNode
   local returnValue

   number = table.maxn (data)
   for i = 1,number do
     chainNode = cff.findChain( data[1])
     if chainNode ~= nil then
        returnValue = cff.processChain( chainNode,queue, event, eventData )
        if returnValue == cf.abort then
           break
        else
          returnValue = cf.continue
        end
    end

   end
   
   returnValue = cf.continue
   return returnValue 
end



--- changeState data[ name, newState ]
function cff.changeState( chainNode,data,queue, event, eventData )
  
  cf.setState( data[1] ,data[2])
  returnValue = cf.continue
  return returnValue 
end

function cff.changeCurrentState( chainNode, data, queue, event, eventData )
   if event == cf.initEvent then
     cf.setState( chainNode.name, data[1] )
     cf.deactivateNode( chainNode,  nil )
   end
  return cf.continue 
end



function cff.wait(  chainNode,data,queue, event, eventData )
 local temp

 if event == cf.initEvent then
     returnValue = cf.halt
  else
   temp = cf.filterParameter( chainNode, data[1] )
   if temp < os.time() then
      returnValue = cf.continue
      cf.deactivateNode( chainNode,  nil )
    else
      returnValue = cf.halt
    end
  end
  return returnValue
end

function cff.waitEvent( chainNode,data,queue, event, eventData )
 local returnValue
 if event == cf.initEvent then
     returnValue = cf.halt
  else
    returnValue = cf.halt
    if data[1] == event then
      if event ==masterEventList.localEvent then
         if eventData ==  data[2]  then
            returnValue = cf.continue
            cf.deactivateNode( chainNode,  nil )
         end
      else
         returnValue = cf.continue
         cf.deactivateNode( chainNode,  nil )
      end 
   end
  end

 return returnValue
end

--- filterEvent  data [ event, eventData,[ function [ function data ]]]
function cff.filterEvent( chainNode,data,queue, event, eventData )
 local returnValue
 local temp
 returnValue = cf.continue
 
 
 if data[1] == event then
   if event ==masterEventList.localEvent then
      if eventData ==  data[2] then
         temp= data[3]
         temp[1](chainNode,temp[2],queue, event, eventData )
         returnValue = cf.halt
      end
   else
   
    temp= data[2]
    temp[1](chainNode,temp[2],queue, event, eventData )
    returnValue = cf.halt
   end
 end   
 return returnValue
end


function cff.chainContinue( chainNode,data,queue, event, eventData )
  local returnValue 
  if event == cf.initEvent then
     returnValue = cf.continue
  else
     returnValue = cf.continue
  end
  return returnValue
end

function cff.halt( chainNode,data,queue, event, eventData )
  local returnValue 
  if event == cf.initEvent then
     returnValue = cf.continue
  else
     returnValue = cf.halt
  end
  return returnValue
end

function cff.reset(  chainNode,data,queue, event, eventData )
  local returnValue
 if event == cf.initEvent then
     returnValue = cf.reset
  else
     returnValue = cf.reset
  end
  return returnValue
end

function cff.abort(  chainNode,data,queue, event, eventData )
  local returnValue 
  if event == cf.initEvent then
     returnValue = cf.continue
  else
     returnValue = cf.abort
  end
  return returnValue
end

function cff.exitLoop(  chainNode,data,queue, event, eventData )
  local returnValue 
  if event == cf.initEvent then
     returnValue = cf.continue
  else
     returnValue = cf.exitLoop
  end
  return returnValue
end

function cff.continueLoop(  chainNode,data,queue, event, eventData )
  local returnValue 
  if event == cf.initEvent then
     returnValue = cf.continue
  else
     returnValue = cf.continueLoop
  end
  return returnValue
end

function cff.chainFlowDebug( chainNode, data, queue,event, eventData )
  if event == cf.initEvent then
    print(data[1])
    cf.deactivateNode( chainNode,  nil )
  end
  return cf.continue
end

function cff.chainFlowLog( chainNode, data, queue,event, eventData )
  if event == cf.initEvent then
     return cf.continue
  end
  if event == cf.termEvent then
     return cf.continue
  end
  print(data[1])
  return cf.continue
end

function cff.chainFlowTrace( chainNode, data, queue, event , eventData )
  if event == cf.initEvent then
   
    cf.traceControl( data[1] )
   
   cf.deactivateNode( chainNode, nil )
  end
  return cf.continue
end


function cff.chainFlowSendEvent( chainNode, data, queue, event , eventData )
  
  if event == cf.initEvent then
    eventSystem.queue( data[1], data[2], data[3] )
    cf.deactivateNode( chainNode, nil )
  end
  return cf.continue
end

function cff.chainFlowSendCbEvent( chainNode, data, queue, event , eventData )
  if event == cf.initEvent then
     eventSystem.queueCB( data[1], data[2], data[3] )
     cf.deactivateNode( chainNode, nil )
  end
  return cf.continue
end

function cff.chainFlowPostEvent( chainNode, data, queue, event, eventData )
  if event == cff.initEvent then
     publishSubscribe.post( data[1], data[2] )
     cf.deactivateNode( chainNode, nil )
  end
  return cf.continue
end
    

function cff.help( chainNode,data,queue, event, eventData )
  print(" .tick                data [ timeDelay -- seconds ] ")
  print(" .delay               data [ timeDelay -- seconds ]  ")
  print(" .waitUntil           data [ timeDelay, verifyfunction, failureFunction ] ")
  print(" .verfify             data [ samplingDelay, verifyfunction, failureFunction ] ")
  print(" .oneShot             data [ function, ... function data ] ")
  print(" .cleanUp             data [ function, ... function data ] ")
  print(" .subChain            data [ subChain ] ")
  print(" .whileChain          data [ testFunction, subChainName ] ")
  print(" .caseChain           data [ choiceFunction, chain,.....chain] ") 
  print(" .parallelChain       data [ chains ... chains] ")
  print(" .changeState         data [ chainName, newState ] ")
  print(" .changeCurrentState  data [ newState ] ")
  print(" .wait                data [ time in epoch seconds ]" )
  print(" .waitEvent           data [ event eventData]"  )
  print(" .filterEvent         data [ event eventData [ function [ function data ] ] ]")
  print(" .continue            returns cf.continue ")
  print(" .halt                returns cf.halt ")
  print(" .reset               returns cf.reset ")
  print(" .abort               returns cf.abort ")
  print(" .exitLoop            returns cf.exitLoop  ")
  print(" .continueLoop        returns cf.continueLoop ")
  print(" .debug               data [ printString ]" )
  print(" .log                 data [ printString ]")
  print(" .trace               data [ traceControl ]")
  print(" .sendEvent           data [ queueName, event, data ]")
  print(" .sendCbEvent         data [ queueName, event, data ]")
  print(" .postEvent           data [ event data ] ") 
  print(" .help()              display commands ")

end


function cff.description()
  return "chain flow utility functions"
end
 

  
