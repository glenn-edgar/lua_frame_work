---
---
--- File: lua_contactss.lua
--- This file sets target contacts for tgs contact
--- 
---
---
---

contacts = {}
contacts.chain = nil
contacts.units = {}
contacts.detailHelp ={}


function contacts.description()
 return "tgs contact manager"
end

function contacts.help( item )
  if item == nil then
    print("\n-- initialization commands ")
    print("tgs.contacts.clear() -- clear contacts data ")
    print("tgs.contacts.setChain( chain ) ) --sets the chain for a contact list")
 
    print("\n--- build contact list ")
    print("tgs.contacts.addAll() -- adds all stores to contact list")
    print("tgs.contacts.addStore( unit )   --adds a store or list of stores to the contact list")
    print("tgs.contacts.removeStore( unit)  -- removes a store or list of stores to the contact list")
    print("tgs.contacts.addStoreList( fileName )  --adds stores in a file to the contact list ")
    print("tgs.contacts.query( queryString ) --adds stores in a file that matches queryString")
    print("tgs.contacts.queryList( queryString ) -- lists stores which match the queryString")
    print("tgs.contacts.makeStoreDataBase( dataBasePath ) --- data base path ")

    print("\n-- diagnostic commands ")
    print("tgs.contacts.dumpChains()  -- list chains in store data base")
    print("tgs.contacts.dumpSelectedChain() --- list selected chain ")
    print("tgs.contacts.dumpStoresInChain() --- list stores in the chain")
    print("tgs.contacts.dumpStores()  --- print selected stores ")
    print("tgs.contacts.dumpRequiredFields()  --list requires fields for a store db")
    print("tgs.contacts.dumpAllFields() --list all fields in a store db")
   
  else
    if ( type( item ) == "string" ) and ( contacts.detailHelp[ item ] ~= nil ) then
      print( contacts.detailHelp[item ] )
    else
      print("unrecognized help option")
    end
  end

end

function contacts.dumpChains()
    tgs.units.dumpChains()
end


function contacts.listStoresInChain()
  assert(tgs.units.verifyChain( chain ) == true,"invalid chain")
  tgs.units.dumpUnits( chain )
end




function contacts.clear()
  contacts.chain = nil
  contacts.units = {}
end

function contacts.setChain( chain )
  assert( tgs.units.verifyChain( chain ) == true, "invalid chain")
  contacts.chain = chain
  contacts.units = {}

end

function contacts.getUnitList()
  local temp
  -- sort contacts units
  temp = contacts.sortContacts( contacts.units)
  return contacts.chain, temp
end


function contacts.addAll()
   contacts.units = tgs.units.getUnitTable( contacts.chain)
end
--
--
-- unit is a string or a list of unit
--
--
function contacts.addStore( unit )
 assert( contacts.chain ~= nil, "need to define chain")
 if type(unit) == "string" then
   contacts.addStoreTemp(unit)
 elseif type(unit) == "table" then
   for i,j in ipairs( unit ) do
     contacts.addStoreTemp( j )
   end
 else
   assert( false, "invalid unit parameter")
 end
end

function contacts.removeStore( unit)  -- removes a store or list of stores to the contact list")
 local temp
 local temp1
 temp = {}
 assert( contacts.chain ~= nil, "need to define chain")
 if type(unit) == "string" then
    table.insert( temp,unit)
 else
   temp = unit
 end
 
 for i,j in ipairs( temp ) do
   contacts.units[ j ] = nil
 end
 

end

function contacts.addStoreList( fileName )
     assert( contacts.chain ~= nil, "need to define chain")
     for line in io.lines(fileName) do 
       if line == nil then return end
       line = string.trim(line)
       contacts.addStoreTemp( line )
     end
end


function contacts.query( queryString )
   local temp1,temp2,key
   temp1 = {}
   assert( contacts.chain ~= nil, "need to define chain")
   key  = tgs.units.getKey( contacts.chain)
   temp1 = tgs.units.getUnitTable( contacts.chain )
   temp2 = ts.query(  queryString, temp1 )
   if temp2 ~= nil then
      for i,j in pairs( temp2 ) do
        contacts.addStoreTemp( j[ key ] )
      end
   end
end

function contacts.queryList( queryString ) -- lists stores which match the queryString"
   local temp1,temp2,key
   temp1 = {}
   assert( contacts.chain ~= nil, "need to define chain")
   key  = tgs.units.getKey( contacts.chain)
   temp1 = tgs.units.getUnitTable( contacts.chain )
   temp2 = ts.query(  queryString, temp1 )
   if temp2 ~= nil then
      print("units which match the query are")
      for i,j in pairs( temp2 ) do
        print( "Unit --", j[ key ] )
      end
   end
end

function contacts.listRequiredFields( )
 local temp
 assert( contacts.chain ~= nil, "need to define chain")
 temp = tgs.units.listRequiredFields( contacts.chain )
 return ts.keys( temp ) 
end

function contacts.listAllFields(  )
 local temp
 assert( contacts.chain ~= nil, "need to define chain")
 temp = tgs.units.listAllFields( contacts.chain )
 return ts.keys( temp ) 
end


---
---
--- This is a debug function
---
---


function contacts.listStores()
 local key
 local temp
 temp = {}
 assert( contacts.chain ~= nil, "need to define chain")
 key = tgs.units.getKey( contacts.chain )
 
 for i,j in pairs(contacts.units) do
 
   table.insert(temp,j[key])
 end
 table.sort(temp)
 return temp
end




function contacts.makeStoreDataBase( dataBasePath )
   local dirList, dirString, key
   --- first make base directory
   
   dirList = string.ssplit( dataBasePath,"/")
  
   dirString = dirList[1]
   table.remove( dirList,1)
   if dirString ~= "" then   os.mkdir(dirString) end
   for i,j in ipairs( dirList) do
     dirString = dirString .. "/".. j
     os.mkdir( dirString)
   end
   
   --- now make the directories of the units
   key = tgs.units.getKey( contacts.chain )
   for i,j in pairs( contacts.units) do
     os.mkdir( dataBasePath.."/"..j[key] )
   end
end



function contacts.dumpSelectedChain() 
  print("selected chain", contacts.chain )
end

function contacts.dumpStoresInChain()
  tgs.units.dumpUnits( contacts.chain )
end

function contacts.dumpStores()
 print( unpack( contacts.listStores()))
end

function contacts.dumpAllFields() 
 print( unpack( contacts.listAllFields() )) 
end

function contacts.dumpRequiredFields()  --list requires fields for a store db")
 print( unpack( contacts.listRequiredFields() ))
end


---
---
--- local support functions
---
---

function contacts.addStoreTemp( unitId )
 local temp
 local key
 

 temp = tgs.units.getEntry( contacts.chain,unitId )

 if temp == nil then print("unit",unit,"unit is not recognized ") return end

 contacts.units[ unitId ] = temp
end

function contacts.sortContacts( units)
 local temp1
 local temp2
 local temp3

 temp1  = {}
 temp2  = {}
 temp3  = {}

  for i,j in pairs( units) do
   table.insert( temp1, j.id )
   temp2[ j.id ] = j
  end
  table.sort(temp1)
  for i,j in ipairs( temp1) do
    table.insert( temp3, temp2[ j] )
  end
return temp3
end
----
----
---- detailled help 
----
----




contacts.detailHelp["clear"] =
[[
tgs.contacts.clear() -- clears the dictionary used to hold the chain and store list.
			This should be the first command issued

]]

contacts.detailHelp["setChain"] =
[[
tgs.contacts.setChain( chain ) --- this command should be the first command after a clear command

Example
tgs.contacts.setChain("TARGET")

]]




contacts.detailHelp["addAll"] = 
[[

tgs.contacts.addAll() -- adds all stores in a chain to a contact list

]]


contacts.detailHelp["addStore"] = 
[[

tgs.contacts.addStore( unit ) )  --adds a store or list of stores to the contact list
Example -- to add a single file
tgs.contacts.addStore("001")
Example -- to add a list of files
tgs.contacts.addStore({"001","002","003","004"})


]]

contacts.detailHelp["removeStore"] = 
[[

tgs.contacts.removeStore( unit ) )  --adds a store or list of stores to the contact list
Example -- to remove a single store
tgs.contacts.removeStore("001")
Example -- to remove a list of files
tgs.contacts.removeStore({"001","002","003","004"})


]]

contacts.detailHelp["addStoreList"] = 
[[
 
tgs.contacts.addStoreList( fileName )  --adds stores listed in the specfied file.
File should have the following form -- store id's one per line and left justified on line
006
007
008
009
010
011
012

]]

contacts.detailHelp["query"] = 
[[

tgs.contacts.query( queryString ) --adds stores to the contact list based upon a query string as shown
in the example below.

tgs.contacts.query( "(ts.entry.tz=='EST') or (ts.entry.tz=='PST')" )
--- results for eastern time zone or Pacific Time zone

The query is written in the form ts.entry."store-field".  Stores which match the query string are added
to the store list

]]



contacts.detailHelp["queryList"] = 
[[

tgs.contacts.queryList( queryString ) --displays strings that match a query string as shown
in the example below.

tgs.contacts.queryList( "(ts.entry.tz=='EST') or (ts.entry.tz=='PST')" )
--- results for eastern time zone or Pacific Time zone

The query is written in the form ts.entry."store-field".  Stores which match the query string are added
to the store list

]]
contacts.detailHelp["dumpRequiredFields"] = 
[[

tgs.contacts.dumpRequiredFields()  --This command provides user support for the query command.  This 
command lists all required fields in for a store entry.

]]

contacts.detailHelp["dumpAllFields"] = 
[[

tgs.contacts.dumpAllFields() --This command provides user support for the query command.  This 
command lists all fields in for a store entry.

]]



contacts.detailHelp["dumpStores"] = 
[[

tgs.contacts.dumpStores()  -- --- This function returns as a list the stores that have been defined by the 
commands such as addStore.  This is a user support command.

]]
contacts.detailHelp["dumpChains"] = 
[[
   
tgs.contacts.dumpChains()  -- This function lists all chains defined in the store dictionary.
This command is for user support.

]]

contacts.detailHelp["dumpSelectedChain"] = 
[[
   
tgs.contacts.dumpSelectedChain()  -- This function lists selected chain
This command is for user support.

]]

contacts.detailHelp["dumpStoresInChain"] = 
[[

tgs.contacts.dompStoresInChain() --- This function lists all the stores in a chain.  This 
function is for user support. The chain is the one previously selected by tgs.contacts.setChain(chain).

]]

contacts.detailHelp["dumpStores"] = 
[[

tgs.contacts.dumpStores()  --- This function prints out the stores that have been defined by the 
commands such as addStore.  This is a user support command.
 
]]

contacts.detailHelp["makeStoreDataBase"] = 
[[

tgs.contacts.makeStoreDataBase( dataBasePath ) --- This function from the base directory path creates empty 
directories which have the storeId as their name.  Useful when downloading logfiles from stores in a chain.  

]]




tgs.contacts = contacts


