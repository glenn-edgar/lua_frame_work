---
---
--- file: tgs_time.lua
--- This file computes time correction
---
---
---
---

tgs_time = {}
tgs_time.tz = "PST"

tgs_time.timeoffset = {}
tgs_time.timeoffset.PST = 8
tgs_time.timeoffset.MST = 7
tgs_time.timeoffset.CST = 6
tgs_time.timeoffset.EST = 5

function tgs_time.generate4400Time( unitEntry)
  local currentTime
  local returnValue
  
  currentTime = os.safeGm()
 
  currentTime.year = currentTime.year-1900
  returnValue = 
      sprintf("%02d/%02d/%04d",currentTime.month, currentTime.day, currentTime.year)
  returnValue = returnValue.."~"
        .. sprintf("%02d:%02d:%02d",currentTime.hour, currentTime.min, currentTime.sec )
 -- print("returnValue",returnValue)
  return returnValue
end


function tgs_time.generateTime()
  local currentTime
  local currentTimeSec
  local diffTime
  local returnValue

  currentTime = os.safeGm()
  returnValue = sprintf("%02d%02d%02d%02d%04d.%02d ",currentTime.month, currentTime.day, 
                                          currentTime.hour,       currentTime.min, currentTime.year, currentTime.sec )
  return returnValue, currentTimeSec
end

function tgs_time.computeTzDiff( a, b )
  local returnValue
  returnValue = tgs_time.timeoffset[a] - tgs_time.timeoffset[b]
  returnValue = returnValue * 3600
  return returnValue
end


function tgs_time.toSec( year,month,day,hour,min ,sec, unitEntry)
  local temp, returnValue
  temp = {}
  temp.year = year
  temp.month = month
  temp.day   = day
  temp.hour  = hour
  temp.min  = min
  temp.sec    = sec
  temp.isdst  = unitEntry.isdst
  returnValue = os.time(temp)
  temp = nil
  return returnValue
end

function tgs_time.toSecGm( year,month,day,hour,min,sec)
  local temp, returnValue
  temp = {}
  temp.year = year
  temp.month = month
  temp.day   = day
  temp.hour  = hour
  temp.min  = min
  temp.sec    = sec
  temp.isdst  = false
  returnValue = os.time(temp)
  temp = nil
  return returnValue
end

