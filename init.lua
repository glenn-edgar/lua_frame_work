

---
---
---  Load Application specific 
---
---
---local status
status =os.dlLoad( os.getcwd().."/user_libraries/libluaExpat.so","lua_registerExpat")
assert(status == 0,"cannot open network libraries ")


status =os.dlLoad( os.getcwd().."/user_libraries/libluaNetwork.so","lua_loadNetworkApps")
assert(status == 0,"cannot open network libraries ")

status =os.dlLoad( os.getcwd().."/user_libraries/libluaSqlite.so","lua_registerSqlite")
assert(status == 0,"cannot open network libraries ")


status =os.dlLoad( os.getcwd().."/user_libraries/libPatString.so","lua_registerPatString")
assert(status == 0,"cannot open pat string libraries ")

--status =os.dlLoad( os.getcwd().."/user_libraries/libC_support.so","lua_loadcJson")
--assert(status == 0,"cannot open c support library")

status =os.dlLoad( os.getcwd().."/user_libraries/libluaSun.so","lua_loadSunrise")
assert(status == 0,"cannot open sun library")

status =os.dlLoad( os.getcwd().."/user_libraries/libRS485.so","lua_cf_controller_rs485_load")
assert(status == 0,"cannot open rs485 library")

status = os.dlLoad( os.getcwd().."/user_libraries/libcf_controller.so","lua_registercontroler")
assert(status==0,"cannot load controller library")


status = os.dlLoad( os.getcwd().."/user_libraries/libbasicCompression.so","lua_basicCompression")
assert(status==0,"cannot load basic compression")

status = os.dlLoad( os.getcwd().."/user_libraries/libluacouchDb.so","lua_loadcouchdb")
assert(status==0,"cannot load couchdb routines")

status = os.dlLoad( os.getcwd().."/user_libraries/libcf_compiler.so","lua_registercontroler")
assert(status==0,"cannot load cf_compiler routines")



status = os.dlLoad(os.getcwd().."/user_libraries/libchain_flow_embedded_compiler.so","lua_registerCompilerFeatures")
assert(status==0,"cannot load chain flow embedded compiler")


status = os.dlLoad(os.getcwd().."/user_libraries/libluaTemplateDb.so","lua_loadTemplateLibrary")
assert(status==0,"cannot load template libraries")

status =os.dlLoad( os.getcwd().."/user_libraries/libluaWeb.so","lua_registerLibrary")
assert(status == 0,"cannot open web library")


status = os.dlLoad( os.getcwd().."/user_libraries/libluaJson.so","lua_registercontroler")
assert(status==0,"cannot load lua JSON")

status = os.dlLoad( os.getcwd().."/user_libraries/libluaCJSON.so","lua_loadcJson")
assert(status==0,"cannot load lua cJSON")



devHandle = rs485.open("/dev/ttyUSB0",4)
assert(devHandle == true,"cannot start 485 interface")

---
---  Load Daily Configuration Scripts
---

--
--
--  load controller application scripts
--
dofile(os.getcwd().."/application_data/init.lua")

cf_auto_controller.initialize()


function processEvents()
cf_auto_controller.masterPoll()
end


---
---
--- Execute any command line arguments
---
---
---








