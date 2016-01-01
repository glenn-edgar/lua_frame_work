---
---
--- File cvs.lua
--- Provides routines to convert cvs to lua tables and lua tables to cvs
---
---
---

cvs = {}


function cvs.description()
  return "cvs processing facilities"
end

function cvs.help()
   print("cvs methods")
   print(".toCvs( tableElement, separator,[ fieldNames ] ) -- return string of cvs Element")
   print(".toTable(string, separator, [fieldNames] ) -- return table ")
   print(".help()  -- prints out package commands")
end


function cvs.toCvs( tableElement,separtor, fieldNames ) 
  local returnValue
  local temp

  returnValue = ""
  if fieldNames == nil then temp = tableElment else temp = fieldNames end
  for i,j in ipairs( temp ) do
    if returnValue == "" then
     returnValue = returnValue .. tableElement[i]
    else
     returnValue = returnValue .. separator..tableElement[i]
    end
  end
  return returnValue
end

function cvs.toTable( inputString, separator, fieldNames )
  local returnValue
  local temp

  returnValue = {}
  temp = string.split(inputString,separator)
  if fieldNames == nil then
   returnValue = temp
  else
   for i,j in ipairs( fieldNames) do
     returnValue[j] = temp[i]
   end
  end
  return returnValue
end
   

