--[[
   File: web_handlers.lua

--]]









function waveArray()
   local dirArray
   local quickJsonArray;

   if web.getRequestMethod() == "GET" then 
      dirArray = os.dir("msg")
      table.remove( dirArray,1 ) -- remove .
      table.remove( dirArray,1 ) -- remove ..
      table.sort(dirArray)
      quickJsonArray = quickJson.encode(dirArray)
      web.dump(quickJsonArray)
 else
   web.dump("'Error'")
 end

end


function generateTextPage()
 local pagerId;
 local textData;
 local webData;
 local status;
 if web.getRequestMethod() == "POST" then
  
  webData = quickJson.decode(web.getPostData())
  pagerId = tonumber(webData[1])
  textData = webData[2]
  status = clxGateway.send_request("tpager ".." "..pagerId.." "..textData)
  web.dump(quickJson.encode(status));
 else
   web.dump(quickJson.encode("ERROR"))
 end
end


function webReboot()
local status
if web.getRequestMethod() == "GET" then 

    status = clxGateway.send_request("reboot")
    web.dump(quickJson.encode(status));

 else
   web.dump("FAIL")
 end
end


function webRestart()
local status
if web.getRequestMethod() == "GET" then 

    status = clxGateway.send_request("restart")
    web.dump(quickJson.encode(status));

 else
   web.dump("FAIL")
 end
end



function generateAudioPage()
 local pagerId;
 local audioFile;
 local webData;
 local status
 
 if web.getRequestMethod() == "POST" then
  
  webData   = quickJson.decode(web.getPostData())
  pagerId   = tonumber(webData[1])
  audioFile = webData[2]
  status = clxGateway.send_request("apager ".." "..pagerId.." "..audioFile)
  web.dump(quickJson.encode(status));
 else
   web.dump(quickJson.encode("ERROR"))
 end
end


function clearSetInputPage()
 local inputNumber;
 local setFlag;
 local webData;
 local status;
 
 if web.getRequestMethod() == "POST" then
  
  webData     = quickJson.decode(web.getPostData())
  inputNumber = tonumber(webData[1])
  setFlag     = webData[2]
  
  status = clxGateway.send_request("input ".." "..inputNumber.." "..setFlag)
  web.dump(quickJson.encode(status));

 else
     web.dump(quickJson.encode("ERROR"))
 end

end

function sendQuickLink()
 local inputNumber;
 local termId;
 local keyId;
 local status;
 
 if web.getRequestMethod() == "POST" then
  
  webData     = quickJson.decode(web.getPostData())
  termId      = tonumber(webData[1])
  keyId       = tonumber(webData[2])
  
  status = clxGateway.send_request("aterm ".." "..termId.." "..keyId)
  web.dump(quickJson.encode(status));

 else
     web.dump(quickJson.encode("ERROR"))
 end

end


function clearSetAlarmPage()
 local alarmNumber;
 local setFlag;
 local webData;
 local status
 if web.getRequestMethod() == "POST" then
 
  webData       = quickJson.decode(web.getPostData())
  alarmNumber   = tonumber(webData[1])
  setFlag       = webData[2]
 

  status = clxGateway.send_request("alarm ".." "..alarmNumber.." "..setFlag)
  web.dump(quickJson.encode(status));

 else
   web.dump(quickJson.encode("ERROR"))
 end


end


function getTxdFile()
 local fileName;
 local object;


 if web.getRequestMethod() == "GET" then
   fileName = web.getVar( "name" )
    object = loadtxd( fileName )

  
     object = quickJson.encode( object)

     
  web.dump(object); 

 else
   web.dump(quickJson.encode("Error"))
 end

end

function storeTxdFile()

local webData;

if web.getRequestMethod() == "POST" then
   fileName = web.getVar( "name" )
    
    webData       = quickJson.decode(web.getPostData())
     
    webData = moveDataDown( webData)
      
    storetxd( fileName, webData );
    web.dump(quickJson.encode("Success"))
 else
   web.dump(quickJson.encode("Error"))
 end
end

function getTxdNamePair()
 local fileName
 local name

if web.getRequestMethod() == "GET" then 
    fileName = web.getVar( "name" )
    object = loadtxd( fileName )
    if object == nil then web.dump("Error") end
    object = filterObject( object)
    --object = quickJson.encode(object);
    object = quickJson.encode( object)
 
     web.dump(object)
 else
   web.dump("Error")
 end

end

function getTextPagers()
if web.getRequestMethod() == "GET" then 
    object = loadtxd( "pagedev" )
    if object == nil then web.dump("Error") end
    object = textFilterObject( object)
    object = quickJson.encode(object);
   
    web.dump(object)

 else
   web.dump("Error")
 end

end

function getAudioPagers()
if web.getRequestMethod() == "GET" then 
   
    object = loadtxd( "pagedev" )
    if object == nil then web.dump("Error") end
    object = audioFilterObject( object)
    object = quickJson.encode(object);
   
    web.dump(object)
 else
   web.dump("Error")
 end

end

function aterm()
local termId
local keyId
local temp
local status
if web.getRequestMethod() == "GET" then 
    
    temp = web.getQueryString()
    temp = string.ssplit(temp,"~")
    termId = temp[1]
    keyId  = temp[2]
    status = clxGateway.send_request("aterm ".." "..termId.." "..keyId)
    web.dump(quickJson.encode(status));

 else
   web.dump("FAIL")
 end
end

function rawQuickLink()
local termId
local keyId
local temp
local status
local cmdString

if web.getRequestMethod() == "GET" then 
    
    temp = web.getQueryString()
    temp = string.ssplit(temp,"~")
    cmd    = temp[1]
    parameter1 = temp[2]
    parameter2 = temp[3]
    cmdString = cmd
    if parameter1 ~= nil then
     cmdString = cmdString.."   ".. parameter1
    end
    if parameter2 ~= nil then
     cmdString = cmdString.. " "..parameter2
    end
    status = clxGateway.send_request(cmdString)
    web.dump(status);

 else
   web.dump("FAIL")
 end
end

---
---
--- Support function
---
---
---



function filterObject( object)
  local returnValue

  returnValue = {}
  for i,j in ipairs( object) do
   
    returnValue[i] = { j.number, j.name} 
  end    
  return returnValue
end



function textFilterObject( object)
  local returnValue
  local k
  
  k = 1
  returnValue = {}
  for i,j in ipairs( object) do
    if j.deviceType == 0 then
       returnValue[k] = { j.number, j.name}
       k = k+1
    end
  end    
  return returnValue
end


function audioFilterObject( object)
  local returnValue
  local k
   
  k = 1
  returnValue = {}
  for i,j in ipairs( object) do
    if j.deviceType == 2 then
       returnValue[k] = { j.number, j.name}
       k = k +1
    end
  end    
  return returnValue
end


function testEmptyTable(x )
  local returnValue

  returnValue = true
  for i, j in pairs( x) do
    returnValue = false
    return returnValue
  end
  return returnValue
end


function moveDataDown( dataArray )
  local returnValue
  local k
  returnValue = {}
  --- handling 1 line entries
  
  if testEmptyTable( dataArray ) == true then return dataArray end

  if dataArray[1] == nil then 
   returnValue[1] = dataArray
   return returnValue
  end

  k =1
  
  for i = 1,#dataArray do
   if type(dataArray[i]) == "table" then
     returnValue[k] = dataArray[i]
     k = k+1
   end
 end
 return returnValue;
end
