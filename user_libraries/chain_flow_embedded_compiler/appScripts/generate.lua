---
---
---  control for generating script code
---
---
---

generate = {}


function generate.sd_card( script_file_name)
    print("insert SD card  -- press return to continue")
    io.stdin:read("*l")
    print("enter drive letter for sd card")
    temp.drive = io.stdin:read("*l")
    ---
    ---
    ---
    print("transferring scripts to sd card")
    temp.card =  temp.drive..":\\scripts\\"
    print(temp.card)
    temp.working_path = lfs.currentdir()
    lfs.mkdir( temp.card)
    lfs.chdir(temp.card)
    --- dump script files
    temp.file = io.open(script_file_name,"w+")
    ---
    ---
    --- Dump out file data
    ---
    ---

    temp.fileList = sc.get_compiled_object()

   for i,j in ipairs( temp.fileList ) do
      temp.file:write(j.."\n")
   end

  temp.file:close()
  --- restore working directory
  lfs.chdir(temp.working_path)
  os.execute("sync")
  print("save to remove drive")

end


function generate.list_file(script_file_name)
    temp.file = io.open(script_file_name.."."..extension,"w+")
    ---
    ---
    --- Dump out file data
    ---
    ---

    temp.fileList = sc.get_compiled_object()

   for i,j in ipairs( temp.fileList ) do
      temp.file:write(j.."\n")
   end

  temp.file:close()
  os.execute("sync")

end

function generate.rs485(port,node_id,block_id, compile_object)
  --- handle =open serial port(port)
  --  send_485_command( handle,node_id,"DISABLE_OFFLINE_MODE" )
  --- send_485_command( handle,node_id,"ERASE_FLASH_BLOCK,"..block_id)
  for i, j in ipairs( compile_object) do
    -- send_485_command( handle,node_id,"STORE_LINE,"..block_id..","..j.."\n")
  end
  --- send_485_command(handle,node_id,"RESET")

  --- 
  --- close serial port

end

function generate.help()
  print("generate transfers compiled objects to external storeage")
  print(".sd_card( script_file_name)  -- transfers to sd_card ")
  print(".rs485(port,node_id,block_id, compile_object)  -- transfers on 485 bus ")
  print(".list_file(script_file_name)   -- transfer compile object to disk file  ")
end

function generate.description()
 return "script compiler output writer"
 end


--[[
require("lfs")  -- importing lua file system

---
---
---  Assemble System
---
---
sc.compile()

---
---
---
print("insert SD card  -- press return to continue")

io.stdin:read("*l")
print("enter drive letter for sd card")
temp.drive = io.stdin:read("*l")


---
---
---


---
---
---  Transfer data to flash card
---






---
---
---
print("transferring scripts to sd card")

temp.card =  temp.drive..":\\scripts\\"
print(temp.card)

temp.working_path = lfs.currentdir()
lfs.mkdir( temp.card)
lfs.chdir(temp.card)

--- dump script files
temp.file = io.open(script_file_name..".txt","w+")




---
---
--- Dump out file data
---
---

temp.fileList = sc.get_compiled_object()

for i,j in ipairs( temp.fileList ) do
  temp.file:write(j.."\n")
end





temp.file:close()

--- restore working directory
lfs.chdir(temp.working_path)

--- save working path
--- transfer working director to drive
--- mkdir script directory
--- cd to script directory
--- dump script files
--- restore working path


]]--

