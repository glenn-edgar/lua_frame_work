---
---
--- File: lua_getTime.lua
--- GET_TIME LUA REPORT
---
---
---
---
---
---



get_time_report = {}


function get_time_report.execute( resultList)
  get_time_report.doTitle( resultList )
  get_time_report.doBad( resultList )
  get_time_report.doDetail(resultList)
end


function get_time_report.doTitle( resultList )
 local temp
 local count

 temp = tgs.reports.filter(resultList , { {"action",actions.ops.getTime} } )
 count = tgs.reports.count( temp )

 reports.addLine(" ")
 reports.addLine("GET TIME Report for "..count.." Stores ")
 reports.addLine(os.date())
 reports.addLine(" ")

end



function get_time_report.doBad( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter( resultList, { {"action",actions.ops.getTime},{"status",false} })
  count = tgs.reports.count(temp)
  reports.addLine("\n\nStores where GET TIME access failed "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == actions.ops.getTime) and ( m.status == false ) then
       tempString = string.format("%d   %s    ",i,m.id )
       reports.addLine( tempString)
     end
   end
  end
end


function get_time_report.doDetail( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter( resultList, { {"action",actions.ops.getTime},{"status",true} })
  count = tgs.reports.count(temp)
  reports.addLine("Stores for which GET TIME  were obtained "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == actions.ops.getTime) and ( m.status == true ) then
       if m.result.mtsTime ~= nil then
          tempString = string.format("%d   %s timeDifference %d ",i,m.id,m.result.mtsTime - m.result.tgsTime )
       else
          tempString = string.format("%d   %s timeDifference time not measured ",i,m.id )
       end
       reports.addLine( tempString)
     end
   end
  end
end






tgs.reports.addReport("GET_TIME_REPORT",get_time_report )

