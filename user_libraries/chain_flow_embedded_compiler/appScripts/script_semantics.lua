----
----
----
---- file: script_semantics.lua
----
----
---- 
----
----

script_semantics = {}

script_semantics.stack = {}

script_semantics.for_x        = 1
script_semantics.while_x      = 2
script_semantics.case_x      = 3


function script_semantics.init()
  script_semantics.stack = {}
end

function script_semantics.pushfor()
   table.insert (script_semantics.stack, 0,script_semanitics.for_x)
end

function script_semantics.pushwhile()
    table.insert (script_semantics.stack, 0,script_semanitics.while_x)
end

function script_semantics.pushcase()
    table.insert (script_semantics.stack, 0,script_semanitics.case_x)
end

function script_semantics.popfor()
  local temp
  temp = table.remove (script_semantics.stack,1)
  assert(temp == script_semantics.for_x ) 
end

function script_semantics.popwhile()
  local temp
  temp = table.remove (script_semantics.stack,1)
  assert(temp == script_semantics.while_x ) 
end

function script_semantics.popcase()
  local temp
  temp = table.remove (script_semantics.stack,1)
  assert(temp == script_semantics.case_x) 
end


function script_semantics.assertempty()
  local temp
  temp = table.remove (script_semantics.stack,1)
  assert(temp == nil ) 
end


function script_semantics.help()
 print("no user based commands ")
 print("this package is used internally by script engine")
end

function script_semantics.description()
 return "script semantics package"
end