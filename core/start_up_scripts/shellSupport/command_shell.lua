---
--- File: command_shell.lua
---
---
---




command_shell = {}
command_shell.commands = {}


command_shell.working_line = ""


function command_shell.addCommand( name, help, detailed_help, command )
   local temp
   temp = {}
   temp.name = name
   temp.help = help
   temp.detailed_help = detailed_help
   temp.command = command
   command_shell.commands[ name ] = temp
end


function command_shell.exec( inputString )
  local temp
  local command
  local fields

  inputString = tostring( inputString )
  inputString = string.trim( inputString)
  inputString = commandShell.expandString( inputString )
  fields = string.split( inputString, " " )
  command = fields[1]

  table.remove(fields,1)  -- removing command field

  if command_shell.commands[ command ] == nil then
    printf("command %s is not recognized", command )
  else
    temp = command_shell.commands[ command ].command
    temp( fields )
  end
end


function command_shell.help( fields )
  if fields[1] == "" then
    print("list of commands")
    for i,j in pairs( command_shell.commands ) do
      printf("   %s \t %s", i ,j.help )
    end
  elseif command_shell.commands[fields[1] ] ~= nil then
     print()
     printf("command %s ", fields[1]  )
     print( command_shell.commands[ fields[1] ].detailed_help)
     print()
  else
     printf("help for %s --> command not recognized",
             command_shell.commands[ fields[1] ] )
  end
end

function command_shell.quit( fields )
  print("terminating .....")
  os.exit()
end

function command_shell.to_lua( fields )
  terminal.to_lua()
end

function command_shell.include( fields )
   shell.executeFile( fields[0] )
end

function command_shell.description()
  return "command shell interpreter"
end


local detailed_help

detailed_help = 
[[
   help   --- displays commands and a short description
   help  "command" --- displays a description of the command
]]

template_help =
[[
   template fille_name optional parameters

A template file is treated as text except for markers in the text where lua text is inserted

<?lua chunk ?> 
Processes and merges the Lua chunk execution results where the markup is located in the template. The alternative form <% chunk %> can also be used. 
<?lua= expression ?> 
Processes and merges the Lua expression evaluation where the markup is located in the template. The alternative form <%= expression %> can also be used.



]]


command_shell.addCommand( "help","provides help information",detailed_help,command_shell.help )
command_shell.addCommand( "quit","terminates program","terminates program",command_shell.quit )
command_shell.addCommand( "exit","terminates program","terminates program", command_shell.quit)
command_shell.addCommand( "to_lua","returns to lua interpreter","returns to lua interpreter",command_shell.to_lua)

command_shell.addCommand("include",
                        "include filename processes command in file",
                        "include filename processes command in file",
                        command_shell.include )

command_shell.addCommand("template",
                         "template filename parameters ... ",
                         template_help,
                         command_shell.template)


--
--
--
-- non global support functions
--
--

function command_shell.expandString( string )

tempFunction = lp.compile(tempString)
 
 tempFunction()

 tempString =nil
 tempFunction = nil
end