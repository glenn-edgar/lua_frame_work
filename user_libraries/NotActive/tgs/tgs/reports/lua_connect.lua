---
---
--- File: lua_connect.lua
--- report for connect action
---  
---
---

connect_report = {}


function connect_report.execute( resultList)
  connect_report.doTitle( resultList )
  connect_report.doBadStores(resultList)
end


function connect_report.doTitle( resultList )
 local temp
 local count

 temp = tgs.reports.filter(resultList , { {"action",tgs.actions.ops.connect} } )
 count = tgs.reports.count( temp )

 reports.addLine(" ")
 reports.addLine("Connect Report for "..count.." Stores ")
 reports.addLine(os.date())
 reports.addLine(" ")

end

function connect_report.doBadStores( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter(resultList, { {"action",tgs.actions.ops.connect},{"status",false} })
  count = tgs.reports.count(temp)
  reports.addLine("Stores for which there is no service connectivity "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == tgs.actions.ops.connect) and ( m.status == false ) then
       tempString = string.format("%d   %s    ",i,m.id )
       reports.addLine( tempString)
     end
   end
  end
end








tgs.reports.addReport("CONNECT_REPORT",connect_report )





