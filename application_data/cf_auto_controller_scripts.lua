---
---
---
--- File: cf_auto_controller_scripts.lua
---
---
---
---


cf_auto_controller.dailyScript = {}
table.insert( cf_auto_controller.dailyScript,{ cf_auto_cmds.reset, {0},3,nil,nil})
table.insert( cf_auto_controller.dailyScript,{ cf_auto_cmds.setTime,{0},3,nil,nil})


cf_autoController.hourScript = {}
table.insert( cf_auto_controller.hourScript,{ cf_auto_cmds.printReport,{200}, 3, nil, nil } )
-- sumarize sunlevel
-- sumarize humidity
-- sumarize temperature
-- sumarize tank level
-- sumarize CO2 level


cf_autoController.minuteScript = {}
-- clear ping status
-- ping each device
-- check ping status
-- record sunlight level
-- record humidity
-- record temperature
-- record co2 level
-- record tank level
-- check intermediate tank level






