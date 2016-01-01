---
---
--- File:dbManagement.lua
---
---
---
dbCtl.file   = nil
dbCtl.valid  = false


table.insert( dbCtl.helpData, { "open(file)", "open data base"})
table.insert( dbCtl.helpData, { "close()", "closes a open data base"})
table.insert( dbCtl.helpData, { "vacuum()", "reclaim open data base space"})

function dbCtl.open( file )
  dbCtl.value =  sqlite.open(file)
  if dbCtl.value == true then
    dbCtl.file = file
    dbCtl.getDbTables()
  end
  return dbCtl.value
end

function dbCtl.close()
  if dbCtl.value == true then
      sqlite.close() 
      dbCtl.value = nil 
      dbCtl.file = nil
  end
end

function dbCtl.vacuum( )
  if dbCtl.value == true then
    sqlite.exec( "vacuum ; ")
  end
end
