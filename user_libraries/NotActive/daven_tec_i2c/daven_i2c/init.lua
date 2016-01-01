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
--
---
--- load TGS application
---
---
status =os.dlLoad( os.getcwd().."/user_libraries/daven_i2c/libdevenTech.so","lua_registerLibrary")
daven_tech_lib.loadScript(os.getcwd() .."/user_libraries/daven_i2c/")

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









