---
---
--- File:  script_commands which are immediately executed
---
---
---

script_commands = {}

function  script_commands.erase_flash_block( flash_block_id )
          assert(flash_block_id ~= nil )
          scripts.add_command("ERASE_FLASH_BLOCK", flash_block_id )
end

function script_commands.store_line(flash_block_id,line)
         assert(flash_block_id ~= nil )
	 assert(line ~= nil )
	 scripts.add_command("STORE_LINE",flash_block_id,line )
end

function script_commands.store_default_block( flash_block_id )
  assert( flash_block_id ~= nil )
  scripts.add_command("STORE_DEFAULT_BLOCK_ID",flash_block_id)
end

function script_commands.run_block( flash_block_id)
  assert( flash_block_id ~= nil )
  scripts.add_command("RUN_BLOCK",flash_block_id)
end

function script_commands.reset( )
  scripts.add_command("RESET")
end



function  script_commands.configure_io( io_configuration )
          assert(io_configuration ~= nil )
          scripts.add_command("CONFIGURE_GPIO", gpio, gpio_state )
end

function  script_commands.set_node( node )
          assert( node ~= nil )
          scripts.add_command("SET_NODE",nodeId )
end

function  script_commands.set_flash( id , value )
          assert( id  ~= nil)
          assert( value ~= nil )
          scripts.add_command("SET_FLASH",id,value )
end

function  script_commands.set_flash_not_int( id, value )
          scripts.add_command("SET_FLASH_NINT",id, value )
end



function script_commands.setVariable( id ,value )
    assert(id ~= nil)
    assert(value ~= nil )
    scripts.add_command("SET_VARIABLE",id,value)
end

function script_commands.getVariableRange( start_index, end_index )
    assert(start_index ~= nil )
    assert(end_index ~= nil )
    scripts.add_command("GET_VARIABLE",start_index,end_index )
end



function script_commands.getFlashRange( start_index, end_index )
    assert(start_index ~= nil )
    assert(end_index ~= nil )
    scripts.add_command("GET_FLASH_VARIABLE",start_index,end_index )
end


function script_commands.setFlashVariable(id,value)
    assert(id ~= nil)
    assert(value ~= nil )
    scripts.add_command("SET_FLASH_VARIABLE",id,value)
end


function script_commands.enableScripts( start_index, end_index )
    assert(start_index ~= nil )
    assert(end_index ~= nil )
    scripts.add_command("ENABLE_SCRIPTS",start_index,end_index )
end



function script_commands.disableScripts( start_index, end_index )
    assert(start_index ~= nil )
    assert(end_index ~= nil )
    scripts.add_command("DISABLE_SCRIPTS",start_index,end_index )
end

function script_commands.setOnline()
    scripts.add_command("ENABLE_ONLINE_MODE")
end

function script_commands.setOffline()
   scripts.add_command("DISABLE_OFFLINE_MODE")
end




function script_commands.help()
  print("list of script commands ")
  print("script commands are commands which are not incorporated in scripts ")
  print("and are executed at run time ")
  print(".erase_flash_block( flash_block_id )  ")
  print(".store_line(flash_block_id,line)         ")
  print(".store_default_block( flash_block_id ) ")
  print(".run_block( flash_block_id)                ")
  print(".reset( )                                           ")
  print(".configure_io( io_configuration )      ")
  print(".set_node( node )                           ")
  print(".set_flash( id , value )                    ")
  print(".set_flash_not_int( id, value)         ")
  print(".setVariable( id ,value )                ")
  print(".getVariableRange( start_index, end_index ) ")
  print(".getFlashRange( start_index, end_index )     ")
  print(".setFlashVariable(id,value)                            ")
  print(".enableScripts( start_index, end_index )      ")
  print(".disableScripts( start_index, end_index )     ")
  print(".setOnline()                                                ")
  print(".setOffline()                                         ")
end

function script_commands.description()
 return "script compiler free form commands"
end 




