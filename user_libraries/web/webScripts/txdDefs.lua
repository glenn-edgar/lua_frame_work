--[[
    File: txdDefs.lua
    This file contains the definitions for txd file formats

--]]
--
--
-- Inverse Month lookup
--
--
local monthMap = { "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC" }
local iMonthMap = {}
iMonthMap.JAN = 1
iMonthMap.FEB = 2
iMonthMap.MAR = 3
iMonthMap.APR = 4
iMonthMap.MAY = 5
iMonthMap.JUN = 6
iMonthMap.JUL = 7
iMonthMap.AUG = 8
iMonthMap.SEP = 9
iMonthMap.OCT = 10
iMonthMap.NOV = 11
iMonthMap.DEC = 12
function iMonth(numberMonth)
 return iMonthMap[ numberMonth]
end







----
----
---- Custom parsing functions
----
----
----

function routeParsing( accessType, fileControl, dataArray, element )
  local returnValue
  if accessType == 0 then -- load option
    element = string.trim( element)
    element = string.replace(element,",","~")
    returnValue = string.ssplit(element,"~")
  else -- store option
   returnValue = table.concat(element,"~")
   returnValue = string.trim(returnValue)
  end
  return returnValue;
end



function audioParsing( accessType, fileControl, dataArray, element )
  local returnValue
  if accessType == 0 then -- load option
    element = string.trim( element)
    returnValue = string.ssplit(element,",")
  else -- store option
   returnValue = table.concat(element,",")
   returnValue = string.trim(returnValue)
  end
  return returnValue;
end

function processDate(accessType, fileControl, dataArray, element )
  local temp
  
  local returnValue
  local month
 
  if accessType == 0 then -- load option
    returnValue = {}
    temp = string.ssplit(element," ")
    returnValue.day  = (temp[1])
    returnValue.month = iMonth(temp[2])
    returnValue.year = tonumber(temp[3])
    if returnValue.year == -1 then
     returnValue.everyYear = 1
    else
      returnValue.everyYear = 0
    end
  
  else -- store Option
     month = tonumber(element.month)
     month = monthMap[month]
     if month == nil then month = "" end
    
     if element.everyYear == 1 then
       element.year = -1
       returnValue = element.day.." "..month.." "..element.year
    else
       returnValue = element.day.." "..month.." "..element.year
    end
    
  end
  
  return returnValue
end

function generateMinusOne(accessType, fileControl, dataArray, element)
  return -1
end

function generateZero(accessType, fileControl, dataArray, element)
  return 0
end  


function parseDate(accessType, fileControl, dataArray, element)
  local temp1
  local temp2
  local returnValue
 
  if accessType == 0 then -- load option
    returnValue = {}
    temp1= string.ssplit( element,"~")
    temp2 = string.ssplit( temp1[1], ":" )
    returnValue.open ={}
    returnValue.open[1] = tonumber(temp2[1])
    returnValue.open[2] = tonumber(temp2[2])
    
    temp2 = string.ssplit( temp1[2], ":" )
    returnValue.close ={}
    returnValue.close[1] = tonumber(temp2[1])
    returnValue.close[2] = tonumber(temp2[2])
    if returnValue.open[1] == -1 then
     returnValue.closed = 1
    else
     returnValue.closed = 0
    end
  else -- store Option
      if element.closed == 1 then 
         element.open[1] = -1
         element.open[2] = "00"
         element.close[1] = 0
         element.close[2] = "00"
       end
       returnValue = sprintf("%02d:%02d~%02d:%02d",tonumber(element.open[1]),tonumber(element.open[2]),
                                               tonumber(element.close[1]),tonumber(element.close[2]))
      
  end
  return returnValue
end
 
 
function dayMsgRef(accessType, fileControl, dataArray, element)
 local returnValue
 local temp

 if accessType == 0 then -- load
  
   temp = {}
   returnValue = {}
   returnValue.from = element
   temp = tonumber(dataArray[ 10 ])
   if temp < 0  then
     temp = -temp
     returnValue.reference = 0;
   else
     returnValue.reference = 1
   end
   returnValue.minute = temp % 60
   returnValue.hour = (temp - returnValue.minute )/60
 
 else -- store option
  temp = element.hour *60 + element.minute
  if tonumber(element.reference) == 0 then
   temp = -temp
  end
  returnValue =  element.from.."|"..temp

 end
 return returnValue
end 


      
function processDow(accessType, fileControl, dataArray, element)
 local returnValue
 local temp


 if accessType == 0 then -- load
   element = tonumber(element)
   returnValue = {}
   if bop.band(element,1) ~= 0 then
    returnValue.Sunday = 1
   else
    returnValue.Sunday = 0
   end
   if  bop.band(element,2) ~= 0  then
    returnValue.Monday = 1
   else
    returnValue.Monday = 0
   end
   if  bop.band(element,4) ~= 0 then
    returnValue.Tuesday = 1
   else
    returnValue.Tuesday = 0
   end
   if bop.band(element,8) ~= 0 then
    returnValue.Wednesday = 1
   else
    returnValue.Wednesday = 0
   end
   if  bop.band(element,16) ~= 0 then
    returnValue.Thursday = 1
   else
    returnValue.Thursday = 0
   end
   if bop.band(element,32) ~= 0 then
    returnValue.Friday = 1
   else
    returnValue.Friday = 0
   end
   if bop.band(element,64) ~= 0 then
    returnValue.Saturday = 1
   else
    returnValue.Saturday = 0
   end
 
 else -- store option
   returnValue = 0;
   if element.Sunday ~= 0 then returnValue = returnValue + 1 end
   if element.Monday ~= 0 then returnValue = returnValue + 2 end
   if element.Tuesday ~= 0 then returnValue = returnValue + 4 end
   if element.Wednesday ~= 0 then returnValue = returnValue + 8 end
   if element.Thursday ~= 0 then returnValue = returnValue + 16 end
   if element.Friday ~= 0 then returnValue = returnValue + 32 end
   if element.Saturday ~= 0 then returnValue = returnValue + 64 end

 end
 return returnValue
end 
 
        
function promoCtl(accessType, fileControl, dataArray, element)
 local returnValue
 local temp

 if accessType == 0 then -- load
  returnValue = {}
  
  returnValue.promo_type = tonumber(dataArray[7]) 
  dataArray[8] = tonumber( dataArray[8])
  if dataArray[8] < 0 then
    returnValue.promo_ref = 0
    dataArray[8] = - dataArray[8]
  else
    returnValue.promo_ref = 1
  end
  
 
  returnValue.promo_minute = dataArray[8] % 60 
  returnValue.promo_hr = ( dataArray[8] - returnValue.promo_minute)/60
  returnValue.promo_from = dataArray[9]

 else -- store option
  temp = tonumber(element.promo_hr)*60 + tonumber(element.promo_minute)
  if tonumber(element.promo_ref) == 0  then
   temp = -temp
  end
  returnValue =  element.promo_type.."|"..temp .."|"..element.promo_from

 end
 return returnValue
end 

---
---
--- misc.txd -- file definition
---

temp = {}
temp.skipLine = 2
temp.lineCnt  = 1
temp.key = nil
temp.generateNumber = nil

temp.fieldList =  { "timeZone", "chainName",
                    "storeName","faxNumber",
                     "ipPhoneNumber","ipUser",
                     "ipPassword","faxName",
                     "lowBatteryAlarm", "inactiveCallBox",
                     "storeCode","lowBatteryThreshold" }
temp.fieldDesc  = { "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "i", 
                    "i",
                    "s",
                    "i" }  

addTxdTable( "misc", "misc", temp )

 
temp = {}
temp.skipLine = 2
temp.lineCnt  = 1

temp.key = nil
temp.generateNumber = nil

temp.fieldList =  { "NetworkIp",    -- 1
                    "NetworkMask",  -- 2
                    "NetworkGateway",--3
                    "PPP_ENABLED",   --4
                    "PPP_ADDRESS",   --5
                    "PPP_MASK",      --6
                    "PPP_routing",   --7
                    "DNS",           --8
                    "MAX_SOCKETS",   --9
                    "WEB_HOME",      --10
                    "WEB_FILE",      --11
                    "FTP_HOME",      --12
                    "FTP_DIR",       --13
                    "FTP_USER",      --14
                    "FTP_PASSWORD",   --15
                    "EMAIL_HOME",    --16
                    "EMAIL_DEST",    --17
                    "EMAIL_SENDER",  --18
                    "EMAIL_NAME",    --19
                    "EMAIL_PASS",     --20
                    "EMAIL_POP",     -- 21
                    "NTP_ENABLE",    --22
                    "NTP"            --23
                   }
                   
temp.fieldDesc  = { "s", -- 1 
                    "s",  --2
                    "s",  -- 3
                    "n",  --4
                    "n",  --5
                    "n",  --6
                    "n",  -- 7
                    "s",  --8
                    "n",  -- 9
                    "n",  -- 10
                    "n",  -- 11
                    "n",  -- 12
                    "n",  -- 13
                    "n",  -- 14
                    "n",   --15
                    "n",   -- 16
                    "n",   -- 17
                    "n",   -- 18
                    "n",   -- 19
                    "n",   -- 20
                    "n",   -- 21
                    "i",   -- 22
                    routeParsing, -- 23
                    }
 

addTxdTable( "netdata","netdata", temp )


temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"
temp.generateNumber = 1

temp.fieldList =  { "termId", 
                    "keyId",
                    "alarmNumber",
                    "action",
                   }
                   
temp.fieldDesc  = { "i", 
                    "i",
                    "i",
                    "i" }
 
addTxdTable( "pos", "pos", temp )

  
temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"


temp.fieldList =  { "number", 
                    "name",
                    "alarmNumber",
                    "wired",
                    "setDelay",
                    "clearDelay",
                    "debounce",
                    "activeLow",
                    "lowBattery",
                    "notUsed",
                    "setCnt",
                    "clearCnt",
                    "enableTime",
                    "disableTime" }

                   
                   
temp.fieldDesc  = { "i", 
                    "s",
                    "i",   
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i" }
 
addTxdTable( "inputs", "inputs", temp )

temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"


temp.fieldList =  { "number",
                    "name",
                    "yearFlag",
                    "year",
                    "alarmMonth",
                    "DowFlag",
                    "todDay",   
                    "alarmNumber",
                    "AlarmHours",
                    "AlarmMinutes",
                    "AlarmSeconds",   }

                   
                   
temp.fieldDesc  = { "i",
                    "s",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i",
                    "i"  }
 
addTxdTable( "todalarm", "todalarm", temp )




temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"


temp.fieldList =  {  
                    "number",
                    "name",
                    "alphaSet",
                    "numericSet",
                    "audioSet",
                    "alphaClear",
                    "numericClear",
                    "audioClear",
                    "repageInterval",
                    "alarmTimeout",
                    "route",
                    "pageTilClear",
                    "scriptName",
                    "scriptParameters",
                    "permissions"  }

                   
                   
temp.fieldDesc  = { "i",
                    "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "s",
                    "i",
                    "i",
                    "i",
                    "i", 
                    "s",
                    "s",
                    "i"  }
 
addTxdTable( "alarms", "alarms", temp )
 






temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"

 

temp.fieldList =  {  
                    "number",
                    "name",
                    "route1",
                    "route2",
                    "route3",
                    "route4"  }

                   
                   
temp.fieldDesc  = { "i",
                    "s",
                    routeParsing,
                    routeParsing,
                    routeParsing,
                    routeParsing  }
 
addTxdTable( "routing", "routing", temp )


temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"

 

temp.fieldList =  {  
                    "number",
                    "name",
                    "deviceType",
                    "sitePagerType",
                    "BaudRate",
                    "capCode",
                    "DialString",
                    "index",
                    "pagerRackLocation",
                    "emailDestination",
                    "emailSubject",
                     "group", }

                   
                   
temp.fieldDesc  = { "i",
                    "s",
                    "i",
                    "i",
                    "i",
                    "s",
                    "s",
                    "i",
                    "i",
                    "s",
                    "s",
                     routeParsing }
 
 
addTxdTable( "pagedev", "pagedev", temp )

temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"

 

temp.fieldList =  {  
                    "number",
                    "message" }

                   
                   
temp.fieldDesc  = { "i",
                    "s"
                   }
 
 
addTxdTable( "canmess", "canmess", temp )


  
  

temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"

temp.fieldList =  {  
                    "number",
                    "name",
                    "startingDate",
                    "startingDow",
                    "weekNumber",
                    "Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday" 

              }
                  
temp.fieldDesc  = { "i",
                    "s",
                    processDate,
                    generateMinusOne,
                    generateMinusOne,
                    parseDate,  -- Sunday
                    parseDate,  -- Monday
                    parseDate,  -- Tuesday
                    parseDate,  -- Wednesday
                    parseDate,  -- Thursday
                    parseDate,  -- Friday
                    parseDate,  -- Saturday
                   }
 


addTxdTable( "storehr", "storehr", temp )

temp = {}
temp.skipLine = 2
temp.lineCnt  = 0
temp.key = "number"

temp.fieldList =  {  
                    "number",
                    "name",
                    "startingDate",
                    "startingDow",
                    "weekNumber",
                    "storeOpen",
                    "storeDay",
                    "storeClose",
                    "dayMsgRef",
                    

                  }
                  
temp.fieldDesc  = { "i",
                    "s",
                    processDate,
                    generateZero,  -- dow
                    generateMinusOne,  -- week
                    routeParsing,  -- store open
                    routeParsing,  -- store close
                    routeParsing,  -- store day
                    dayMsgRef, 
                    "blank"
                   }
 
 
addTxdTable( "answer", "answer", temp )

temp = {}
temp.skipLine = 4
temp.lineCnt  = 0
temp.key = "number"

temp.fieldList =  {  
                    "number",
                    "name",
                    "waveFiles",
                    "startingDate",
                    "endingDate",
                    "dow",
                    "promoCtl",
                    "blank",
                    "blank",
                    "route",
                    "enable" 

                  }
                  
temp.fieldDesc  = { "i",  -- number
                    "s",   -- name
                    audioParsing,
                    processDate,  -- starting Date
                    processDate,  -- ending Date
                    processDow,  -- dow
                    promoCtl,  -- promo control
                    "blank",  -- 
                    "blank",  -- 
                    "i",    -- route
                    "i",    -- enable
                   }
 
 
addTxdTable( "promos", "promos", temp )

temp = {}
temp.skipLine = 2
temp.lineCnt  = 1


temp.fieldList =  {  
                    "interval"

                  }
                  
temp.fieldDesc  = { "i",  -- interval

                    }
 
 
addTxdTable( "promosCtl", "promos", temp )

---
---
---
--- Parsing functions
---
---
---
---

