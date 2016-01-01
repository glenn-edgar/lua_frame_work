---
---
--- File: unitss.lua
--- This does the following things
--- 1.  Coordinates the units data bases
--- 2.  Verifies a units in a chain
--- 3.  Verifies the unitss in a file list
--- 4.  Generates the complete list of unitss in a chain
--- 5.  Gets a units record

---
---
--- The entry for a units contains the following fieds
---  unitsDir     --- units directory
---  telephone
---  telephoneExt
---  ipAddress
---


---
--- 
---

tgs.units.chains = {}

function tgs.units.verifyChain( chain )
   local returnValue
   
   if tgs.units.chains[chain] ~= nil then
     returnValue = true
   else
     returnValue = false
   end
   return returnValue

end

function tgs.units.verifyUnit( chain, unitsId )
  local returnValue
  local temp

  returnValue = false

  temp = tgs.units.chains[ chain ]
  if temp ~= nil then
     if temp.unitsList[unitsId] ~= nil then
       returnValue = true
     end
  end
  return returnValue
end

function tgs.units.getChain( chain)
   local temp
   local returnValue
   local i,j


   returnValue = {}
   temp = tgs.units.chains[ chain ]
   if temp == nil then  return returnValue end
   
   for i,j in pairs( temp.unitsList ) do
     table.insert( returnValue, j[ temp.key] )
   end
   table.sort( returnValue )
   return returnValue
end


function tgs.units.getUnit( chain , unitsId )
   local temp
   local returnValue
   
   returnValue = nil
   
    temp = tgs.units[ chain ]

    if temp ~= nil then 
     returnValue = temp.unitsList[ units ]
    end

    return returnValue
end



function tgs.units.verifyTable( j, entry )
  local returnValue

  returnValue = false
  for i,j in ipairs( j) do
    if j == entry then returnValue = true end
  end
  return returnValue
end



function tgs.units.verifyField( i, j, entry )
  local returnValue
  returnValue = true

  if type(j) == "table" then
    returnValue = tgs.units.verifyTable( j, entry)
  else
    if type(j) == "function" then
      returnValue = j(entry )
    end
  end
  return returnValue
end




function tgs.units.verifyEntry( unitsControl, entry,key )
   local returnValue
   local temp
   returnValue = true
   temp = unitsControl.requiredFields
   for i,j in pairs( temp ) do
     if entry[i] == nil then 
        print("bad field",j,entry[key]) returnValue = false 
     else
       if tgs.units.verifyField( i, j,entry[i] ) == false then returnValue = false end
     end
   end
   return returnValue
end


function tgs.units.addChain( unitsControl ,unitsList )
  local temp,errorStr
  unitsControl.unitsList = {}
  -- verify tgs.units table
   assert( unitsControl.requiredFields[ unitsControl.key] ~= nil,"key is not defined") 
   for i,j in ipairs( unitsList ) do
     errorStr = sprintf("chain %s  units %s ",unitsControl.name, j[ unitsControl.key])
     assert( tgs.units.verifyEntry( unitsControl, j, unitsControl.key ),errorStr)
     unitsControl.unitsList[ j[unitsControl.key] ] = j
   end
   tgs.units.chains[ unitsControl.name ] = unitsControl
end

function tgs.units.getEntry( chain,unitId )
 local temp, entry 

  assert( tgs.units.chains[chain] ~= nil,"chain not registered")
  temp = tgs.units.chains[ chain]
  
  entry = temp.unitsList[ unitId ] 
  return entry

end
---
---
--- dump a unit entry
---
---
---
function tgs.units.dumpEntry( chain, unitId )
  local temp, entry
  

  assert( tgs.units.chains[chain] ~= nil,"chain not registered")
  temp = tgs.units.chains[ chain]
  
  entry = temp.unitsList[ unitId ] 
  if entry == nil then print("unitId was not found") return end
  for i, j in pairs( entry ) do
    print("field",i,"value",j)
  end
end
---
---
--- dumps the units 10 units a line
---
---
function tgs.units.dumpUnits( chain )
  local temp, key, tempIndex, tempList
  local unitsControl

  assert( tgs.units.chains[chain] ~= nil,"chain not registered")
  temp = tgs.units.chains[ chain]
  key = temp.key
  tempIndex = {}
  for i,j in pairs( temp.unitsList ) do
   table.insert(tempIndex,j[ temp.key] )
  end
  table.sort(tempIndex)
  for i = 1, #tempIndex, 10 do
   tempList = {}
   for j = 1,10 do
     if  i+ j-1 <= #tempIndex then tempList[j] = temp.unitsList[ tempIndex[ i+j-1] ][key] end
   end
   print(unpack(tempList))
  end
end

function tgs.units.dumpChains()
 local temp
 temp = {}
 for i,j in pairs(tgs.units.chains) do
   table.insert(temp,i)
 end
 table.sort(temp)
 print("Current Supported Chains")
 for i,j in ipairs( temp ) do
  print(j)
 end
 print("")
end

function tgs.units.listRequiredFields( chain )
   local temp
   temp = {}
   assert( tgs.units.chains[chain] ~= nil,"chain not registered")
   for i,j in pairs( tgs.units.chains[chain].requiredFields ) do
    temp[i] = true
   end
   return temp
end

function tgs.units.listAllFields( chain )
 local temp
 temp = {}
 assert( tgs.units.chains[chain] ~= nil,"chain not registered")
 for i, j in pairs( tgs.units.chains[chain].unitsList ) do
  for k,l in pairs( j ) do
    temp[k] = true
  end
 end
 return temp
end

function tgs.units.getUnitTable(chain)
 local temp, entry
  

  assert( tgs.units.chains[chain] ~= nil,"chain not registered")
  temp = tgs.units.chains[ chain].unitsList
  return temp
end

function tgs.units.getKey( chain )
  assert( tgs.units.chains[chain] ~= nil,"chain not registered")
  return tgs.units.chains[ chain].key
end

function tgs.units.help()
 print("these functions maintain the units data base")
 print("tgs.units.verifyChain( chain ) -- verifies if chain is registered")
 print("tgs.units.verifyUnit( chain, unitId ) -- verify unitId is in chain")
 print("tgs.units.getUnit( chain , unitsId ) -- returns units entry ")
 print("tgs.units.getChain( chain) -- returns list of units id's ")
 print("tgs.units.addChain( chain, unitsCtl ) -- adds a units chain to the system")
 print("tgs.units.getKey( chain ) -- get key field of table")
 print("tgs.units.getUnitTable(chain)  -- get unit table")
 print("tgs.units.getEntry( chain,unitId ) -- returns entry record ")
 print("tgs.units.dumpEntry( chain, unitId ) -- dumps entry in db ") 
 print("tgs.units.dumpUnits( chain ) -- dumps the units in a chain")
 print("tgs.units.dumpChains() -- dumps registered chains ")
 print("tgs.units.listRequiredFields( chain ) -- returns table of required fields ")
 print("tgs.units.listAllFields( chain ) -- returns all fields in a store ")
end