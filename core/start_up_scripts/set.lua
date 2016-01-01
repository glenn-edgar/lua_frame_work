---
---
--- File: set.lua
---
---
---
---

set_ops = {}

function set_ops.description()
  return "set operations"
end

function set_ops.help()
 print("set operations ")
 print(".new() --- creates new set")
 print(".add(set, element) -- add element")
 print(".remove( set,element ) -- remove element")
 print(".union(set1,set2) -- union operation")
 print(".intersection(set1,set2) -- intersection operation")
 print(".difference( set1,set2) -- difference operation")
 print(".tolist( set) -- converts set to sorted list")
end

function set_ops.new()
  local returnValue
  returnValue = {}
  return returnValue
end


function set_ops.add( set, element )
  if type( element) ~= "table" then
    set[ element ] = 1 
  else
    for i,j in pairs( element) do
      set[j] = 1
    end
  end
end

function set_ops.remove( set,element)
  if type( element) ~= "table" then
    set[ element] = nil
  else
    for i,j in pairs( element ) do
      set[j] = nil
    end
  end
end

function set_ops.union( set1, set2 )
  local returnValue

  returnValue = {}

  for i,k in pairs( set1 ) do
    returnValue[i] = 1
  end
 
  for i,k in pairs( set2 ) do
    returnValue[i] = 1
  end
  return returnValue
end

function set_ops.intersection( set1, set2 )
  local returnValue

  returnValue = {}

   for i,k in pairs( set1 ) do
     if set2[i] ~= nil then
      returnValue[i] = 1
     end
   end
   return returnValue
end

function set_ops.difference( set1, set2 )
  local returnValue

  returnValue = {}

   for i,k in pairs( set1 ) do
     if set2[i] == nil then
      returnValue[i] = 1
     end
   end
   return returnValue
end

function set_ops.tolist( set)
  local returnValue

  returnValue = {}

  for i,j in pairs( set ) do
    table.insert(returnValue,tostring(i))
  end

  table.sort( returnValue)
  return returnValue
end
