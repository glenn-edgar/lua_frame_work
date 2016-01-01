---
--- File: common_code.lua
--- The purpose of this file is to incapsulate common device code
---  ping, echo and time delay
---
---

common_device_code = {}

function common_device_code.ECHO( parameters, actionResult, chain, unitEntry )
   actionResult.status = true
   actionResult.result.status = parameters[1]
   print( parameters[1] )
   return actionResult.status
end

function common_device_code.TIME_DELAY(parameters, actionResult, chain, unitEntry )
  local timeDelay
  timeDelay = parameters[1]
  os.execute("sleep "..timeDelay)
  actionResult.status = true
  actionResult.result.timeDelay = timeDelay
  actionResult.result.status = "time delay of "..timeDelay
  return actionResult.status
end


function common_device_code.PING_GATEWAY( parameters, actionResult, chain, unitEntry )
  local count, success, pingCounts, ipAddress, temp
  count = tonumber(parameters[1])
  success = tonumber(parameters[2])
   if (unitEntry.tel ~= nil) and ( unitEntry.tel ~= "") then actionResult.status = 1 return end
  if chain.getGateWay ~= nil then 
   ipAddress = chain.getGateWay( unitEntry)
  else
   actionResult.result.tries = count
   actionResult.result.ipAddress = "not defined"
   actionResult.result.success = 1
   actionResult.result.pingCounts = 0
   actionResult.result.status = "could not determine gateway"
   return actionResult.result.status
  end
  pingCounts = pingTest.ping( ipAddress, count )
  if pingCounts >= success then
    actionResult.status = true
  else
    actionResult.status = false
  end
  actionResult.result.tries = count
  actionResult.result.ipAddress = ipAddress
  actionResult.result.success = success
  actionResult.result.pingCounts = pingCounts
  actionResult.result.status = sprintf("counts %d limit %d results %d",count,success,pingCounts)
  return actionResult.status
end





function common_device_code.PING( parameters, actionResult, chain, unitEntry )
  local count, success, pingCounts, ipAddress, temp
  count = tonumber(parameters[1])
  success = tonumber(parameters[2])
  if (unitEntry.tel ~= nil) and ( unitEntry.tel ~= "") then actionResult.status = 1 return end
  ipAddress = unitEntry.ip
  pingCounts = pingTest.ping( ipAddress, count )
  if pingCounts >= success then
    actionResult.status = true
  else
    actionResult.status = false
  end
  actionResult.result.tries = count
  actionResult.result.ipAddress = ipAddress
  actionResult.result.success = success
  actionResult.result.pingCounts = pingCounts
  actionResult.result.status = sprintf("counts %d limit %d results %d",count,success,pingCounts)
  return actionResult.status
end



