---
---
--- File: lua_ping_gateway.lua
---
---
---
---

ping_gateway_report = {}


function ping_gateway_report.execute( resultList)
 ping_gateway_report.doTitle( resultList )
 ping_gateway_report.doBadStores(resultList)
end


function ping_gateway_report.doTitle( resultList )
 local temp
 local count

 temp = tgs.reports.filter(resultList , { {"action",tgs.actions.ops.pingGateWay} } )
 count = tgs.reports.count( temp )

 reports.addLine(" ")
 reports.addLine("Ping Gateway Report for "..count.." Stores ")
 reports.addLine(os.date())
 reports.addLine(" ")

end

function ping_gateway_report.doBadStores( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter(resultList, { {"action",tgs.actions.ops.pingGateWay},{"status",false} })
  count = tgs.reports.count(temp)
  reports.addLine("Stores for which there is no gateway connectivity "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == tgs.actions.ops.pingGateWay) and ( m.status == false ) then
       tempString = string.format("%d   %s    tries %d  success %d ",i,m.id,m.result.tries,m.result.pingCounts)
       reports.addLine( tempString)
     end
   end
  end
end








tgs.reports.addReport("PING_GATE_WAY_REPORT", ping_gateway_report )



