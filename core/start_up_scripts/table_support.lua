---
--- File: table_support.lua
---
---
---

ts = {}

function ts.hasKey( x, key)
 local returnValue
 if x[key] ~= nil then
   returnValue = true
 else
   returnValue = false
 end
 return returnValue
end

function ts.keys(x )
 local temp
 temp = {}
 for i,j in pairs(x) do
   table.insert(temp,i)
 end
 return temp
end

-- dumps entries of table
function ts.dump(x,sep)
 local  sep_table

 if type(x) ~= "table" then return end
 
 for i,j in pairs( x ) do
  if type(j) == "table" then
    if sep == nil then
       print( i,"expanding table" )
    else
       print(sep,i,"expanding table")
    end
    if sep == nil then
      sep = "-->"
    else
       sep = "--|"..sep
    end
    ts.dump(j,sep)
    sep = string.sub(sep,4)
    if sep == "" then
       sep = nil
    end
  else
     if sep ~= nil then
       print(sep,i,j)
     else
       print(i,j)
     end
  end
 end
end

-- dumps array part of table
function ts.idump(x)
  for i,k in ipairs(x) do
   print(i,k)
  end
end

function ts.sort(x)
  local temp


  returnValue = {}
  temp = {}
  for i,j in pairs(x) do
   table.insert(temp,tostring(i))
  end
  table.sort(temp)
  return temp
end
--
--- Following code if from lua wiki site
---
---
---- This function returns a deep copy of a given table. 
---- The function below also copies the metatable to the new table if there is one, so the behaviour of the copied table is the same as the original. 
---  But the 2 tables share the same metatable, you can avoid this by changing this 'getmetatable(object)' to '_copy( getmetatable(object) )'.

function ts.deepcopy(object)
  local lookup_table = {}
  local function _copy(object)
     if type(object) ~= "table" then
          return object
      elseif lookup_table[object] then
          return lookup_table[object]
     end
     local new_table = {}
     lookup_table[object] = new_table
     for index, value in pairs(object) do
          new_table[_copy(index)] = _copy(value)
      end
      return setmetatable(new_table, getmetatable(object))
   end
   return _copy(object)
 end


--
--
-- Map is a function that takes a list of data and returns a single value
-- reduce function has the following prototype reduceFunction( previousValue, index, value )
-- previousValue is initially nil
--
function ts.reduce( reduceFunction, table )
  local temp

  temp = nil

  for i,j in pairs( table ) do
   temp =  reduceFunction( temp, i,j)
  end

  return temp
end



--
--
-- Map is a function that takes and input and applies it to a list of data 
-- returns two tables 
-- filterFunction has the prototype of function( index, value ) and returns true or false
--
function ts.map( mapFunction, table )
  local temp

  temp = {}

  for i,j in pairs( table ) do
    table.insert( temp, mapFunction( i,j))
  end

  return temp
end
--
--
--
-- Filter function is a function that takes table input and returns true or false
-- returns two tables
-- first table is the list that 
-- filterFunction has the prototype of function( index, value ) and returns true or false
--
function ts.filter( filterFunction, table )
  local temp1
  local temp2
  temp1 = {}
  temp2 = {}
  for i,j in pairs( table ) do
    if  filterFunction(i,j) then
      temp1[i] = j
    else
      temp2[i] = j
    end

  end
  return temp1,temp2
end


function ts.query( querystring, table )
  local temp
  local fn
  local returnValue


  returnValue = {}
  temp = "return "..querystring
  fn = loadstring(temp)
  if fn ~= nil then
    for i,entry in pairs( table ) do
       ts.entry = entry

       if  fn() then
   
         returnValue[i] = entry
       
        
       end
     end
  else
   print("logic expression did not compile")
  end
  return returnValue
end


function ts.list( table ) 
  for i,j in pairs( table) do
   print("index",i,"type",type(i),"value",j,"type",type(j) )
  end
end

function ts.deepEqual( table1, table2 )
  --- this function is tbd
end


function ts.description()
  return "lua table support functions"
end

function ts.help()
 print("functions for table support")
 print(".hasKey(table,key) -- returns true if entry or false if false")
 print(".keys() -- returns key of table")
 print(".dump(x) --- dumps content of a table")
 print(".sort(x) --- single level table sort")
 print(".idump(x) --- dumps content of an array")
 print(".deepcopy(x) -- creates new instance of a object")
 print(".map(listOfFunctions, data) --- returns a list where each function is applied to data")
 print(".reduce(listOfFunctions,list_of_data -- similar to python reduce") 
 print(".filter(filterFunction,table) -- sorts table into two tables of match and no match ")
 print(".query( querystring, table ) -- query for table entries must ref entry.field " )
 print(".list( table ) -- prints returns type of table ")
 print(".deepEqual(table1,table2) -- returns true if tables have equal components")
end

---
---
--- Following code if from lua wiki site
---
---
---- This function returns a deep copy of a given table. 
---- The function below also copies the metatable to the new table if there is one, so the behaviour of the copied table is the same as the original. 
---  But the 2 tables share the same metatable, you can avoid this by changing this 'getmetatable(object)' to '_copy( getmetatable(object) )'.

 
----------------------------------------------
-- Pickle.lua
-- A table serialization utility for lua
-- Steve Dekorte, http://www.dekorte.com, Apr 2000
-- Freeware
 ----------------------------------------------

    function pickle(t)
      return Pickle:clone():pickle_(t)
    end

    Pickle = {
      clone = function (t) local nt={}; for i, v in t do nt[i]=v end return nt end 
    }

    function Pickle:pickle_(root)
      if type(root) ~= "table" then 
        error("can only pickle tables, not ".. type(root).."s")
      end
      self._tableToRef = {}
      self._refToTable = {}
      local savecount = 0
      self:ref_(root)
      local s = ""

      while table.getn(self._refToTable) > savecount do
        savecount = savecount + 1
        local t = self._refToTable[savecount]
        s = s.."{\n"
        for i, v in t do
            s = string.format("%s[%s]=%s,\n", s, self:value_(i), self:value_(v))
        end
        s = s.."},\n"
      end

      return string.format("{%s}", s)
    end

    function Pickle:value_(v)
      local vtype = type(v)
      if     vtype == "string" then return string.format("%q", v)
      elseif vtype == "number" then return v
      elseif vtype == "table" then return "{"..self:ref_(v).."}"
      else --error("pickle a "..type(v).." is not supported")
      end  
    end

    function Pickle:ref_(t)
      local ref = self._tableToRef[t]
      if not ref then 
        if t == self then error("can't pickle the pickle class") end
        table.insert(self._refToTable, t)
        ref = table.getn(self._refToTable)
        self._tableToRef[t] = ref
      end
      return ref
    end

 ----------------------------------------------
 -- unpickle
 ----------------------------------------------

function unpickle(s)
      if type(s) ~= "string" then
        error("can't unpickle a "..type(s)..", only strings")
      end
      local gentables = loadstring("return "..s)
      local tables = gentables()
      
      for tnum = 1, table.getn(tables) do
        local t = tables[tnum]
        local tcopy = {}; for i, v in t do tcopy[i] = v end
        for i, v in tcopy do
          local ni, nv
          if type(i) == "table" then ni = tables[i[1]] else ni = i end
          if type(v) == "table" then nv = tables[v[1]] else nv = v end
          t[ni] = nv
        end
      end
      return tables[1]
end

 
