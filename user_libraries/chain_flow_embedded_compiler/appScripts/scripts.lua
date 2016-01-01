-- lua_extensions.lua

scripts = {}   -- script compiler object


scripts.script_map = {}
scripts.number_of_scripts = 0
scripts.current_id = nil
scripts.compiled_object = {}
scripts.working = {}
scripts.commands = {}


function scripts.compile()
    -- add other object as required
    scripts.compiled_object = {}
    for i,j in ipairs( script.commands ) do
      table.insert( scripts.compiled_object,scripts.expand_command(j) )
    end
    scripts.generate_script( scripts.compiled_object)
end



function scripts.generate_script( temp )
  local temp1, temp2

  for i,j in ipairs(scripts.script_map) do
    temp1 = "START_SCRIPT,"..j.script_id..","..j.auto_start
    table.insert(temp,temp1)
    scripts.expand_script( j, temp)
     temp1 = "END_SCRIPT"
    table.insert(temp,temp1)
 end

end


function scripts.expand_command( j )
  local temp1
  temp1 = j.command
  if j.param1 ~= nil then temp1 = temp1 .."'"..param1 end
  if j.param2 ~= nil then temp1 = temp1 .."'"..param2 end
  if j.param3 ~= nil then temp1 = temp1 .."'"..param3 end
  return temp1
end


function scripts.expand_script(j, temp )
  local temp1
  for i,j in ipairs(j.commands) do
    temp1 = "ADD_ELEMENT,"..j.opcode..","..j.param1..","..j.param2..","..j.param3
   table.insert(temp,temp1)
  end

end


---
--- Auto start value are 0 normal
---                                 1 auto start
---                                 2 auto stop
---

function scripts.define_script( script_id, auto_start, description )
 local temp1

 print("starting script",script_id)
 script_semantics.init()
 scripts.working = {}
 scripts.working.auto_start = auto_start
 scripts.working.description = description
 scripts.working.script_id  = script_id
 scripts.working.commands = {}
 scripts.current_id = script_id
 scripts.number_of_scripts = sc.number_of_scripts +1
 scripts.current_id = script_id
end



function scripts.add_link( opcode, param1, param2, param3 )
  local temp
  temp = {}

   print(opcode,param1,param2,param3)
  if param1 == nil then param1 = -1 end
  if param2 == nil then param2 = -1 end
  if param3 == nil then param3 = -1 end

  if param1 == true then param1 =  1 end
  if param2 == true then param2 =  1 end
  if param3 == true then param3 =  1 end

  if param1 == false then param1 = 0 end
  if param2 == false then param2 = 0 end
  if param3 == false then param3 = 0 end


  temp.opcode = opcode
  temp.param1  = param1
  temp.param2  = param2
  temp.param3  = param3
  table.insert(scripts.working.commands,temp)
  temp = nil
end

function scripts.end_script()
  print("ending script",scripts.current_id)
  script_semantics.assertempty()
  table.insert(scripts.script_map,scripts.working)
  scripts.current_id = nil
end

function scripts.add_command( command, param1,param2,param3 )
 temp = {}
 temp.command = command
 temp.param1    = param1
 temp.param2    = param2
 temp.param3    = param3
 table.insert(scripts.script_commands.temp)
end

function scripts.help()
  print("public functions are as follows")
  print("scripts.define_script( script_id, auto_start, description ) ")
  print("       script_id is a numeric id identifing the script ")
  print("      auto_start parameter has following values ")
  print("          0 normal     ")
  print("          1 auto start ")
  print("          2 auto stop  ")
  print("  doc string describing the purpose of the script ")
  print("scripts.end_script() -- ends a script ")
  print("scripts.compile() -- compiles a sequence of loaded scripts")
end

function scripts.description()
 return "script compiler main package"
end
