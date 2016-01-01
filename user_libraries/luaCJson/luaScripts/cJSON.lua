---
--- File: cJSON.lua
--- cJSON add on using a lua Script
---
---

function cJSON.nestedFields( refObj, fields )
  local temp,temp1
  temp1 = refObj
  for i,j in ipairs( fields) do
     temp = cJSON.getObject( temp1, j )
     if temp == nil then return nil end
     temp1 = temp
  end
  return temp
end

function cJSON.appendArray( data)
  local returnValue

  returnValue = cJSON.createArray()
  for i,j in ipairs( data) do
    cJSON.putArray( returnValue, cJSON.size( returnValue ),j)
  end
  return returnValue
end


function cJSON.luaToJsonObject( luaTable )
  local returnValue
  returnValue = cJSON.createObject()
  for i,j in pairs( luaTable) do
    if type(j) =="table" then
     temp = cJSON.toObject( j) 
     cJSON.putObject(returnValue,i,temp);
    else
      cJSON.putObject( returnValue,i,j)
    end
  end
  return returnValue
end


function cJSON.luaToJsonArray( luaTable )
  local returnValue
  returnValue = cJSON.createArray()
  for i,j in ipairs( luaTable) do
    if type(j) =="table" then
     temp = cJSON.toArray( j) 
     cJSON.putArray(returnValue,i,temp);
    else
      cJSON.putArray( returnValue,i,j)
    end
  end
  return returnValue
end

function cJSON.deleteArray( cJSONPtr, index)
  local temp
  temp = cJSON.detachArray( cJSONPtr,index)
  if temp ~= nil then
    cJSON.free(temp)
  end
end
 
function cJSON.deleteObject( cJSONPtr, name)
  local temp
  temp = cJSON.detachObject( cJSONPtr,name)
  if temp ~= nil then
    cJSON.free(temp)
  end
end




