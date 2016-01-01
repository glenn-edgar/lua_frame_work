---
---
--- Function tql.lua
--- Table Query Language
---
--- definition of list of patterns
--- string -- literal match
--- "*"    -- always match
--- "?"    -- always match till neighbor matches
--- function -- applies function( table )
--- list { field, value }

tql = {}

function tql.description()
 return "implements table query language"
end

function tql.help()
 print(".count( table ) --- returns top level table count")
 print(".sort( table ) --- returns table in sorted manner")
 print(".collect( table, list_of_patterns ) --- pattern match ")
end

function tql.count( table)
 local returnValue
 
  returnValue = 0
  for i,j in pairs( table ) do
    returnValue = returnValue +1
  end
  return returnValue
end

function tql.sort( table )
  local returnValue 
  local temp1
  local temp2

  temp1 = ts.sort( table )
  returnValue = {}

  for i,j in pairs( temp ) do
    temp2 = { j, table[j] }
    table.insert( returnValue, temp2 )
  end
  return returnValue
end

function tql.it_top( table ) 
  