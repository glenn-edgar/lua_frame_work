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



set_time_report = {}


function set_time_report.execute( resultList)
  set_time_report.doTitle( resultList )
  set_time_report.doBad( resultList )
  set_time_report.doDetail(resultList)
end


function set_time_report.doTitle( resultList )
 local temp
 local count

 temp = tgs.reports.filter(resultList , { {"action",actions.ops.setTime} } )
 count = tgs.reports.count( temp )

 reports.addLine(" ")
 reports.addLine("SET TIME Report for "..count.." Stores ")
 reports.addLine(os.date())
 reports.addLine(" ")

end



function set_time_report.doBad( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter( resultList, { {"action",actions.ops.setTime},{"status",false} })
  count = tgs.reports.count(temp)
  reports.addLine("Stores where SET TIME access failed "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == actions.ops.setTime) and ( m.status == false ) then
       tempString = string.format("%d   %s    ",i,m.id )
       reports.addLine( tempString)
     end
   end
  end
end


function set_time_report.doDetail( resultList )
  local temp
  local count
  local tempString
  local tempTime
  local zeroTime

  zeroTime = 0

  temp = tgs.reports.filter( resultList, { {"action",actions.ops.setTime},{"status",true} })
  count = tgs.reports.count(temp)
  reports.addLine("\n\nStores for which SET TIME  were obtained "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == actions.ops.setTime) and ( m.status == true ) then
       tempTime = m.result.mtsTime - m.result.tgsTime
       if tempTime == 0 then zeroTime = zeroTime +1 end
       if tempTime < 0 then
          tempString = string.format("%d   %s (%d)Slow ",i,m.id, -tempTime )
       end
       if tempTime > 0 then
          tempString = string.format("%d   %s (%d)Fast ",i,m.id, tempTime )
       end
 
       reports.addLine( tempString)
     end
   end
  end
  reports.addLine("") reports.addLine("") 
  reports.addLine("Stores requiring no adjustment: "..zeroTime )

end






tgs.reports.addReport("SET_TIME_REPORT",set_time_report )

