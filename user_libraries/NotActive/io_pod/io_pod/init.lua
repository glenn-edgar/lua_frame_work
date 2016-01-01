---
--- copyright 2008 Onyx Engineering
--- this file is licensed as MIT
--- File: init.lua
--- Purpose: Initialize Scripting Environment
---
---
---
---


eventInitialization( )

---
---
---  Load Application specific 
---
---
local io_pod_LdStatus
local io_pod_cmd
---
--- load TGS application
---
---
io_pod_LdStatus =os.dlLoad( os.getcwd().."/user_libraries/io_pod/libluaio_pod.so","lua_registerLibrary")
io_pod.loadScript(os.getcwd() .."/user_libraries/io_pod/")

---
---
--- Execute any command line arguments
---
---
---



if mainArgs.number() > 1  then
 for i = 1 , mainArgs.number() -1 do
   print("processing file",mainArgs.arg(i))
   dofile (mainArgs.arg(i))
 end
 os.exit()
end

---
---
--- This is interactive Mode
---
---









