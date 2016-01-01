---
---
--- File: ping.lua
--- This file implements a ping test
---
---
---
---
---
---


pingTest = {}

function pingTest.ping( ipAddress, pingCount )
  local strBuffer
  local testString
  local count
  local pat1
  local pat2
  
  pat1 = patStr.create()
  pat2 = patStr.create()
  
  os.execute("ping -c  " .. pingCount .." ".. ipAddress .. "  > pingTest")
  strBuffer = strBuf.create(50000)
  strBuf.appendFile(strBuffer,"pingTest")
  patStr.toPat(pat1,strBuf.getBuffer(strBuffer),strBuf.bufLen(strBuffer)-strBuf.freeLen(strBuffer))
  patStr.copy(pat2,pat1,0,-1)
  patStr.matchBetween(pat2,"transmitted,","received",0)
  count = patStr.integer(pat2,10)
  
  patStr.terminate(pat1)
  patStr.terminate(pat2)
  strBuf.terminate(strBuffer)
  return count
end
