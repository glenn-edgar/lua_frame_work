---
--- File: script_opcodes
---
---  These are commands which are compiled
---
---
---
---


script_opcodes = {}

script_opcodes.lt = 1
script_opcodes.le  = 2
script_opcodes.eq = 3
script_opcodes.ge = 4
script_opcodes.gt = 5
script_opcodes.boolean = 6

function script_opcodes.while_x( var_ref, opcode, var_compare)
  assert( var_ref ~= nil )
  assert( opcode ~= nil )
  assert( var_compare ~= nil )
  script.add_link("WHILE",var_ref,opcode,var_compare)
 end

function script_opcodes.end_while()
  --- 
  --- Add semantic checks
  script_semantics.popwhile()
  script.add_link("END_WHILE")
end  

function script_opcodes.for_x(start_var,end_var)
 assert(start_var ~= nil )
  assert(end_var ~= nil )
  script.add_link("FOR",start_var,end_var)
end


function script_opcodes.end_for()
 --- 
 --  semantic checks
 script_semantics.popfor()
 script.add_link("END_FOR")
 
 end

function script_opcodes.case_x( case_var, default_path)
 assert(case_var ~= nil )
 script.add_link("CASE",case_var,default_path)
end


function script_opcodes.end_case()
 ---
 ---
 script_semantics.popcase()
 script.add_link("END_CASE")
 end


 
 function script_opcodes.execute_script( script_id)
  assert(script_id ~= nil )
  script.add_link("EXECUTE_SCRIPT",script_id)
end
 
 
function script_opcodes.set_constant(var,constant)
 assert(var ~= nil)
 assert(constant ~= nil)
 if type(constant) == "boolean" then
   if constant == true then constant = 1 else constant = 0 end
 end
 script.add_link("SET_CONSTANT",var,(constant-constant%256)/256,constant%256)
end

function script_opcodes.zero_array(var_start,var_end)
  assert(var_start ~= nil)
  assert(var_end ~= nil)
  script.add_link("ZERO_ARRAY",var_start,var_end)
end  

function script_opcodes.stop()
   script.add_link( "STOP" )
end

function script_opcodes.reset()
   script.add_link( "RESET" )
end

function script_opcodes.halt()
  script.add_link("HALT")
end



function script_opcodes.wait_system_event( system_event,var1,var2 ) -- var1 and var2 are places to place optional parameters associated with event
  assert( system_event ~= nil )
  script.add_link("WAIT_SYSTEM_EVENT",(system_event-system_event%256)/256,system_event%256)
end

function script_opcodes.send_system_event( system_event,parameter) -- system event limited 16 bit  parameter is optional 8 bit value
  assert( system_event ~= nil )
  script.add_link("SEND_SYSTEM_EVENT",(system_event-system_event%256)/256,system_event%256,parameter)
end

function script_opcodes.enable_script( script_start, script_end )
  assert(script_start ~= nil)
  assert(script_end ~= nil)
  script.add_link("ENABLE_SCRIPT", script_id,script_end)
end

function script_opcodes.disable_script( script_start, script_end )
  assert(script_start ~=nil )
  assert(script_end ~= nil )
  script.add_link("DISABLE_SCRIPT", script_id,script_end)
end

function script_opcodes.enable_script_if( var, script_start, script_end )
  assert( var ~= nil )
  assert(script_start ~= nil )
  assert(script_end ~= nil )
  script.add_link("ENABLE_SCRIPT_IF",var,script_start,script_end)
end

function script_opcodes.disable_script_if( var,script_start,script_end )
  assert(var ~= nil )
  assert(script_start ~= nil )
  assert(script_end ~= nil) 
  script.add_link("DISABLE_SCRIPT_IF",var,script_start,script_end )
end

function script_opcodes.stobe_watch_dog()
  script.add_link("STROBE_WATCH_DOG")
end

function script_opcodes.set_event_mask( event_mask )
  assert(event_mask ~= nil )
  script.add_link("SET_EVENT_MASK",
                          (event_mask-event_mask%(256*256))/(256*256)
                          ,(event_mask-event_mask%(256))/(256)
			  , event_mask%256 )

end

function script_opcodes.set_alarm_mask(alarm_mask)
  assert(alarm_mask ~= nil ) 
  script.add_link("SET_ALARM_MASK",
                          (alarm_mask-alarm_mask%(256*256))/(256*256)
                          ,(alarm_mask-alarm_mask%(256))/(256)
			   ,alarm_mask%256 )
end			   




function script_opcodes.wait_event_mask( event_mask )
  assert(event_mask ~= nil )
  script.add_link("WAIT_EVENT_MASK",
                          (event_mask-event_mask%(256*256))/(256*256)
                          ,(event_mask-event_mask%(256))/(256)
			   ,event_mask%256 )

end

function script_opcodes.wait_alarm_mask(alarm_mask)
  assert(alarm_mask ~= nil ) 
  script.add_link("WAIT_ALARM_MASK",
                          (alarm_mask-alarm_mask%(256*256))/(256*256)
                          ,(alarm_mask-alarm_mask%(256))/(256)
			   ,alarm_mask%256 )
end			   


function script_opcodes.wait_not_event_mask( event_mask )
  assert(event_mask ~= nil )
  script.add_link("WAIT_NOT_EVENT_MASK",
                          (event_mask-event_mask%(256*256))/(256*256)
                          ,(event_mask-event_mask%(256))/(256)
			   ,event_mask%256 )

end

function script_opcodes.wait_not_alarm_mask(alarm_mask)
  assert(alarm_mask ~= nil ) 
  script.add_link("WAIT_NOT_ALARM_MASK",
                          (alarm_mask-alarm_mask%(256*256))/(256*256)
                          ,(alarm_mask-alarm_mask%(256))/(256)
			   ,alarm_mask%256 )
end			   




function script_opcodes.move_from_flash( appVariable, flashVariable )
 assert( appVariable ~= nil)
 assert( flashVariable ~= nil )
 script.add_link("MOVE_FROM_FLASH",appVariable, flashVariable )
end

function script_opcodes.move_to_flash( flashVariable,appVariable )
  assert(flashVariable ~= nil )
  assert( appVariable ~= nil )
  script.add_link("MOVE_TO_FLASH",flashVariable,appVariable )
end


function script_opcodes.verify( var,op_code, limit_var)
  assert( var ~= nil )
  assert( limit_var ~= nil )
  script.add_link( "VERIFY", var, op_code, limit_var )
end



function script_opcodes.verify_range( var, lower, upper )
 assert(var ~= nil )
 assert(lower ~= nil )
 assert(upper ~= nil )
 script.add_link( "VERIFY_RANGE",value,lower,upper )
end

function script_opcodes.verify_not_range( var, lower,upper )
 assert(var ~= nil )
 assert(lower ~= nil )
 assert(upper ~= nil )
 script.add_link( "VERIFY_NOT_RANGE",value,lower,upper )
end


function script_opcodes.verify_monitor( var, op_code, limit_var)
  assert( var ~= nil )
  assert( limit_var ~= nil )
  script.add_link( "VERIFY_MONITOR", var, op_code, limit_var )
end


function script_opcodes.verify_monitor_range( value, lower, upper )
 assert(value ~= nil )
 assert(lower ~= nil )
 assert(upper ~= nil )
 script.add_link( "VERIFY_MONITOR_RANGE",value,lower,upper )
end

function script_opcodes.verify_monitor_not_range( var, lower,upper )
 assert( var ~= nil )
 assert( lower ~= nil )
 assert( upper ~= nil)
 script.add_link( "VERIFY_MONITOR_NOT_RANGE",value,lower,upper )
end

function script_opcodes.monitor( var, op_code, limit_var)
  assert( var ~= nil )
  assert( limit_var ~= nil )
  script.add_link( "MONITOR", var, op_code, limit_var )
end


function script_opcodes.monitor_range( value, lower, upper )
 assert(value ~= nil )
 assert(lower ~= nil )
 assert(upper ~= nil )
 script.add_link( "MONITOR_RANGE",value,lower,upper )
end

function script_opcodes.monitor_not_range( var, lower,upper )
 assert( var ~= nil )
 assert( lower ~= nil )
 assert( upper ~= nil)
 script.add_link( "MONITOR_NOT_RANGE",value,lower,upper )
end








---
---
--- Arithmetic functions
---
---







function script_opcodes.or_bits( var, start_index, end_index)
  assert( var ~= nil )
  assert( start_index ~= nil )
  assert( end_index ~= nil )
  script.add_link( "OR_BITS", var, starting_index, end_index )
end

function script_opcodes.and_bits( var, start_index, end_index )
   assert( var ~= nil )
   assert( start_index ~= nil )
   assert( end_index ~= nil )
   script.add_link( "AND_BITS", var, starting_index, ending_index )
end





function script_opcodes.find_min( storeage_var, starting_var, ending_var)
   assert( storeage_var ~= nil )
   assert( starting_var ~= nil )
   assert( ending_var ~= nil )
   script.add_link( "FIND_MIN", storeage_var, starting_var, ending_var )
end

function script_opcodes.find_max( storeage_var, starting_var, ending_var)
   assert( storeage_var ~= nil )
   assert( starting_var ~= nil )
   assert( ending_var ~= nil )
   script.add_link( "FIND_MAX", storeage_var, starting_var, ending_var )
end


function script_opcodes.debounce(var_ref,var_entry,count )
  assert(var_ref ~= nil )
  assert(var_entry ~= nil )
  assert(count ~= nil )
  script.add_link("DEBOUNCE",var_ref, var_entry,count )
end

function script_opcodes.filter_var(var_sum,var_entry,count)
 assert(var_sum ~= nil)
 assert(var_entry ~= nil )
 assert( count ~= nil )
 script.add_link("FILTER",var_sum,var_entry,count )
end


function script_opcodes.set_counter( var, constant ) -- constant is a 16 bit value
  assert(var ~= nil)
  assert(constant ~= nil )
  script.add_link("SET_CONSTANT",var,(constant-constant%256)/256,constant%256)
end

function script_opcodes.clear_counter( var )
    assert(var ~= nil)
    script.add_link("SET_CONSTANT",var,0,0)
end

function script_opcodes.increment_counter( var,constant )
  assert(var ~= nil )
  assert(constant ~= nil) 
  script.add_link("INCREMENT",var,(constant-constant%256)/256,constant%256)
end

function script_opcodes.decrement_counter(var, constant )
  assert(var ~= nil )
  assert(constant ~= nil)
  script.add_link("DECREMENT",var,(constant-constant%256)/256,constant%256)
end







---
---  time functions
---
---


function script_opcodes.delay( ticks_100_ms )
 assert( ticks_100_ms ~= nil )
 script.add_link( "DELAY_100ms", ticks_100_ms )
end



function script_opcodes.get_second( var)
  assert(var ~= nil)
  script.add_link("GET_SECOND",var )
end

function script_opcodes.get_minute( var)
  assert(var ~= nil )
  script.add_link("GET_MINUTE",var)
end

function script_opcodes.get_hour( var )
  assert(var ~= nil)
  script.add_link("GET_HOUR",var)
end

----
----
---- io functions
----



function script_opcodes.set_gpio( gpio, state )
 assert( gpio ~= nil )
 assert( state ~= nil )
 script.add_link( "SET_GPIO", gpio, state )
end

function script_opcodes.read_gpio( gpio,var )
 assert( gpio ~= nil )
 script.add_link( "READ_GPIO",gpio,var )
end

function script_opcodes.read_a_to_d( var, a_d_channel)
  assert( var ~= nil )
  assert( a_d_channel ~= nil )
  script.add_link("READ_A_TO_D",var,a_d_channel)
end

function script_opcodes.read_i2c( device,address,var)
 assert( device ~= nil )
 assert( var ~= nil )
 script.add_link("READ_I2C",address,var )
end

function script_opcodes.write_i2c(device,address,var)
 assert( device ~= nil )
 assert( var ~= nil )
 script.add_link("WRITE_I2C",address,var )
end

function script_opcodes.read_spi( device,address,var)
 assert( device ~= nil )
 assert( var ~= nil )
 script.add_link("READ_SPI",address,var )
end

function script_opcodes.write_spi(device,address,var)
 assert( device ~= nil )
 assert( var ~= nil )
 script.add_link("WRITE_SPI",address,var )
end


---
---
--- ADD IN PWM LATER
---
---
---
---

function script_opcodes.help()
   print(".while_x( var_ref, opcode, var_compare)  ")
   print(".end_while()                                           ")
   print(".for_x(start_var,end_var)                          ")
   print(".end_for()                                                ")
   print(".case_x( case_var, default_path)             ")
   print(".end_case()                                            ")
   print(".execute_script( script_id)                      ")
   print(".set_constant(var,constant) -- constant is 16 bit value ")
   print(".zero_array(var_start,var_end)          ")
   print(".stop()                                             ")
   print(".script_opcodes.reset()                    ")
   print(".script_opcodes.halt()                         ")
   print(".script_opcodes.wait_system_event( system_event,var1 ) -- system event limited to 16 bit parameter var1 used to store parameter ")
   print(".script_opcodes.send_system_event( system_event,parameter) -- system event limited 16 bit  parameter is optional 8 bit value        ")
   print(".script_opcodes.enable_script( script_start, script_end )                     ")
   print(".script_opcodes.disable_script( script_start, script_end )                    ")
   print(".script_opcodes.enable_script_if( var, script_start, script_end )           ")
   print(".script_opcodes.disable_script_if( var,script_start,script_end )            ")
   print(".script_opcodes.stobe_watch_dog()                                                  ")
   print(".script_opcodes.set_event_mask( event_mask )                               ")
   print(".script_opcodes.set_alarm_mask(alarm_mask)                                  ")
   print(".script_opcodes.wait_event_mask( event_mask )                                ")
   print(".script_opcodes.wait_alarm_mask(alarm_mask)                                   ")
   print(".script_opcodes.wait_not_event_mask( event_mask )                          ")
   print(".script_opcodes.wait_not_alarm_mask(alarm_mask)                             ")
   print(".script_opcodes.move_from_flash( appVariable, flashVariable )         ")
   print(".script_opcodes.move_to_flash( flashVariable,appVariable )               ")
   print(".verify( var,op_code, limit_var)                                                          ")
   print(".verify_range( var, lower, upper )                                                     ")
   print(".verify_not_range( var, lower,upper )                                                 ")
   print(".verify_monitor( var, op_code, limit_var)                                             ")
   print(".verify_monitor_range( value, lower, upper )                                       ")
   print(".verify_monitor_not_range( var, lower,upper )                                       ")
   print(".monitor( var, op_code, limit_var)                                                       ")
   print(".monitor_range( value, lower, upper )                                                 ")
   print(".monitor_not_range( var, lower,upper )                                                ")
   print(".or_bits( var, start_index, end_index)                                                  ")
   print(".and_bits( var, start_index, end_index )                                                 ")
   print(".find_min( storeage_var, starting_var, ending_var)                               ")
   print(".find_max( storeage_var, starting_var, ending_var)                              ")
   print(".debounce(var_ref,var_entry,count )                                                   ")
   print(".filter_var(var_sum,var_entry,count)                                                   ")
   print(".set_counter( var, constant ) -- constant is a 16 bit value                   ")
   print(".clear_counter( var )                                                                            ")
   print(".increment_counter( var,constant )                                                    ")
   print(".decrement_counter(var, constant )                                                  ")
   print(".delay( ticks_100_ms )                                                                         ")
   print(".get_second( var)                                                                               ")
   print(".get_minute( var)                                                                               ")
   print(".get_hour( var )                                                                                 ")
   print(".set_gpio( gpio, state )                                                                      ")
   print(".read_gpio( gpio,var )                                                                      ")
   print(".read_a_to_d( var, a_d_channel)                                                     ")
   print(".read_i2c( device,address,var)                                                      ")
   print(".write_i2c(device,address,var)                                                      ")
   print(".read_spi( device,address,var)                                                      ")
   print(".write_spi(device,address,var)                                                      ")

end

function script_opcodes.description()
 return "script command package"
end


