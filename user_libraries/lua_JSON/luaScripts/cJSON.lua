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

function cJSON.appendArray( refObj, data)
  cJSON.putArray( refObj, cJSON.size( refObj), data)
end

function cJSON.toObject( luaTable )
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

function cJSON.toArray( luaTable )
  local returnValue
  returnValue = cJSON.createArray()
  for i,j in pairs( luaTable) do
    if type(j) =="table" then
     temp = cJSON.toArray( j) 
     cJSON.putArray(returnValue,i,temp);
    else
      cJSON.putArray( returnValue,i,j)
    end
  end
  return returnValue
end

function cJSON.removeArray( cJSONPtr, index)
  local temp
  temp = cJSON.detachArray( cJSONPtr,index)
  if temp ~= nil then
    cJSON.free(temp)
  end
end
 
function cJSON.removeObject( cJSONPtr, index)
  local temp
  temp = cJSON.detachObject( cJSONPtr,index)
  if temp ~= nil then
    cJSON.free(temp)
  end
end



cJSON.helpArray = 
{
  ".to_string( cJsonPtr) -- returns JSON string",
  ".to_JSON( string  ) -- returns cJSON ptr    ",
  ".print( cJsonPtr) -- returns formated JSON string  ",
  ".free( cJsonPtr)  -- frees cJSON ptr  ",
  ".createArray()   -- returns cJSON Array ptr  ",
  ".createObject()  -- returns cJSON Object ptr  ",
  ".size(cJsonPtr)  -- returns number of children  ",
  ".getArray(cJsonPtr,index) -- return object pointer  ",
  ".putArray(cJsonPtr,index,data,tableType)   ",
  ".detachArray(cJSONPtr,index) ",
  ".removeArray(cJSONPtr,index) ",
  ".getObject(cJsonPtr,fieldName)",
 ".putObject(cJsonPtr,fieldName,data,tableType)   ",
 ".detachObject(cJSONPtr,fieldName) ",
 ".removeObject(cJSONPtr,fieldName) ",
 ".appendArray( refObj, data)  appends an object to an array ",
 ".toArray( luaTable ) converts a lua table to an array   ",
 ".getChild( refObj) -- returns child element    ",
".toObject( luaTable) converts lua table to an object ",
 ".getType( refObj) -- returns child element    ",
 ".getField( refObj) -- returns child element    ",
 ".getString( refObj) -- returns child element    ",
 ".getInteger( refObj) -- returns child element    ",
 ".getDouble( refObj) -- returns child element    ",
 ".nestedFields( refObj, fields ) -- returns nested element from list of fields ",
  ".help()    -- dumps out commands ",
 "note use json utility to take JSON string to lua "

}

function cJSON.help()
 for i,j in ipairs( cJSON.helpArray) do
  print(j)
 end
end
