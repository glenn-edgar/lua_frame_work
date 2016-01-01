---
---
--- File: lua_ping_report.lua
---
---
---
---

ping_report = {}


function ping_report.execute( resultList)
  ping_report.doTitle( resultList )
  ping_report.doBadStores(resultList)
end


function ping_report.doTitle( resultList )
 local temp
 local count

 temp = tgs.reports.filter(resultList , { {"action",tgs.actions.ops.ping} } )
 count = tgs.reports.count( temp )

 reports.addLine(" ")
 reports.addLine("Ping Report for "..count.." Stores ")
 reports.addLine(os.date())
 reports.addLine(" ")

end

function ping_report.doBadStores( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter(resultList, { {"action",tgs.actions.ops.ping},{"status",false} })
  count = tgs.reports.count(temp)
  reports.addLine("Stores for which there is no network connectivity "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == tgs.actions.ops.ping) and ( m.status == false ) then
       tempString = string.format("%d   %s    tries %d  success %d ",i,m.id,m.result.tries,m.result.pingCounts)
       reports.addLine( tempString)
     end
   end
  end
end








tgs.reports.addReport("PING_REPORT", ping_report )



