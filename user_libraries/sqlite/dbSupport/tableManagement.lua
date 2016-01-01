---
---
---
--- File: tableManagement.lua
--- This file provides object support for table management
---

dbCtl.tables = {}

table.insert( dbCtl.helpData,
  { "assembleQuery( keyField, query)","takes query list and assemble associative array" } )


table.insert( dbCtl.helpData, 
     { "createTable( tableName, fieldDescriptor)", 
       "creates a table "} )

table.insert( dbCtl.helpData,
              { "dropTable( tableName )","deletes a table" } )

table.insert( dbCtl.helpData,
              { "getFields( tableName )","get fields of a table" } )
table.insert( dbCtl.helpData,
              { "listTables()","list tables associated with a data base" })

table.insert( dbCtl.helpData,
              { "dbCtl.getDbTables()","fetches table fields list" })


function dbCtl.createTable( name, fieldDescriptor, tempflag  )
  local template
  local i,j,x,y,comma

  if dbCtl.tables[ name ] ~= nil then return end

  if tempflag == true then
   template = "CREATE TEMP TABLE "..name.." ( "
  else
   template = "CREATE TABLE "..name .." ( "
  end
  comma = " "
  for i,j in ipairs( fieldDescriptor ) do
     template = template ..comma.. "  "..j[1]..
                "   "..j[2] .." "
     comma = ","
  end
  template = template .." ); "
  print(template)
  x, y = sqlite.exec( template )
  print(x,y)
  dbCtl.getDbTables()
end


function dbCtl.dropTable( tableName )
  local template

  if dbCtl.tables[ tableName ] ~= nil then
    template = "DROP TABLE tableName ;"
    dbCtl.tables[ tableName ] = nil
    sqlite.exec(template)
  end
end


function dbCtl.getFields( tableName )

  local returnValue
  local i,j, temp

  returnValue = {}
  if dbCtl.tables[ tableName ] == nil then return returnValue end
  temp =  dbCtl.tables[ tableName ].fields 
  for i,j in pairs( temp ) do
    table.insert( returnValue,j["name"] )
  end
  return returnValue
end

function dbCtl.listTables( )
  local returnValue
  returnValue = {}
  for i,j in pairs( dbCtl.tables) do
    table.insert( returnValue,i)
  end
  return returnValue
end


function dbCtl.assembleQuery( keyField, query)
  local returnValue
  local i,j

  returnValue = {}
  for i,j in pairs( query ) do
     returnValue[ j[keyField] ] = j
  end
  return returnValue
end 
  

function dbCtl.getDbTables()
  local x,y
  local tables
 
  x,y = sqlite.exec("select * from sqlite_master;")
  dbCtl.tables = dbCtl.assembleQuery("name", x )
  for i,j in pairs( dbCtl.tables ) do
   x,y = sqlite.exec("PRAGMA table_info("..i..");")
   dbCtl.tables[i].fields = dbCtl.assembleQuery("name",x)
  end
  
end






