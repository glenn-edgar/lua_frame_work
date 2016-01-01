---
---
--- File:  cf_auto_cmds.lua
---
---
---



cf_auto_cmds = {}

function cf_auto_cmds.printReport( nodeId )
 cf_send_cmd.printReport(nodeId)
end




function cf_auto_cmds.setTime(nodeId)
  cf_send_cmd.setTime(nodeId)
end

function cf_auto_cmds.reset(nodeId)
  cf_send_cmd.reset(nodeId)
end

function cf_auto_cmds.setVar( nodeId, varType, var, value)
  cf_send_cmd.setVar( nodeId,varType,var,value)
end

function cf_auto_cmds.getVar( nodeId, varType, var)
  cf_send_cmd.getVar(nodeId,varType,var)
end






