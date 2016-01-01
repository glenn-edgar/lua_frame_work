--[[
     file class.lua
     Glenn Edgar
     This file is used to create lua classes.
     Code is taken from
     http://lua-users.org/wiki/LuaClassesWithMetatable
--]]




function Class(members)
  members = members or {}
  local mt = {
    __metatable = members;
    __index     = members;
  }
  local function new(_, init)
    return setmetatable(init or {}, mt)
  end
  local function copy(obj, ...)
    local newobj = obj:new(unpack(arg))
    for n,v in pairs(obj) do newobj[n] = v end
    return newobj
  end
  members.new  = members.new  or new
  members.copy = members.copy or copy
  return mt
end

--[[
Vector = {}

local Vector_mt = Class(Vector)

function Vector:new(x,y)
  return setmetatable( {x=x, y=y}, Vector_mt)
end

function Vector:mag()
  return math.sqrt(self:dot(self))
end

function Vector:dot(v)
  return self.x * v.x + self.y * v.y
end


v1 = Vector:new(3,4)
table.foreach(v1,print)
print( v1:mag() )
v2 = Vector:new(2,1)
print( v2:dot(v1) )

table.foreach(Vector,print)

v3 = v1:copy()
print( v1, v2, v3 )

table.foreach(v1,print) 
table.foreach(v3,print)
--]]
