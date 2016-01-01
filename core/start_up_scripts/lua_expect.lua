---
--- File: lua_expect.lua
--- The purpose of this file is to implement basic Expect type functions
--- Need to better match the expect functions
---
---
---
---

lua_expect = {}

function lua_expect.help()

end


function lua_expect.description()
 return "provides basic expect type functions"
end


function lua_expect.match( readFunction, writeFunction, matchList )
  local returnValue, matchString, writeString, temp, matchResult, dummy
  returnValue = true

  for i,j in ipairs( matchList ) do
    matchString = j[1]
    writeString = j[2]
    temp = readFunction()
    if matchString ~= nil then
       matchResult, dummy = string.find(temp,matchString)
       if matchResult == nil then returnValue = false return returnValue end
    end
    if writeString ~= nil then writeFunction( writeString) end
  end

  return returnValue
end


function lua_expect.extract( readFunction, writeFunction,extractList)
  local returnValue = {}
  local promptString
  local dataKey

  for i,j in ipairs( extractList ) do
    promptString = j[1]
    dataKey      = j[2]
    print("promtString",promptString,dataKey)
    if promptString ~= nil then
     writeFunction( promptString )
     os.execute("sleep 1")
     returnValue[ dataKey ] = readFunction()
    end
  end
  ts.dump(returnValue)
  return returnValue
end


