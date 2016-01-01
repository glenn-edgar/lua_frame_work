
ram_ctl = {}


function ram_ctl.initialize_ram( ram_size)
  local temp
  assert(ram_size ~= nil )
  assert(ram_size <= 256) -- all ram areas have a size limitation of 256
  script_commands.ram = {}
  script_commands.ram.size = ram_size
  script_commands.ram.pages = {}
  for i=1,script_commands.ram.size do
    script_commands.ram.pages[i] = true
  end
end

function ram_ctl.reserve_ram( location )
  local temp
   assert( script_commands.ram.pages[location] ~= nil,"bad RAM page")
   assert( script_commands.ram.pages[location] == true,"already reserved location")
   script_commands.ram.pages[location] = false
   return location
end


function ram_ctl.allocate_ram( allocation_size)
  for i = 1,script_commands.ram.size-allocation_size+1 do
     if script_commands.check_pages( i,allocation_size) == true then
	    for j = i,i+allocation_size-1 do
	      script_commands.ram.pages[j] = false
         end

	    return i
	 end
   end
   assert(false,"block size "..allocation_size.." cannot be allocated")

end

function ram_ctl.check_pages( start,size )
 assert( start+size-1 <= script_commands.ram.size,"out of ram space start "..start.."  size "..size.." ram size "..script_commands.ram.size )
 for i = start, start+size-1 do
   if script_commands.ram.pages[i] == false then return false end
   if script_commands.ram.pages[i] == nil then assert("should not be here") end
  end
  return true
end

function ram_ctl.help()
  print("user commands which manipulate mem buffer ")
  print(".initialize_ram(ram_size) -- ram size limited to a max of 256 16 bit values ")
  print(".reserve_ram(location) -- reserve a ram cell at a fixed lolation ")
  print(".allocate_ram( allocation_size) -- allocates a continuous area of ram values ")
end

function ram_ctl.description()
return "script compiler ram allocator"
end