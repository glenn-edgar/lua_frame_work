---
---
--- file: lua_getFile.lua
---
---
---

get_file_report = {}


function get_file_report.execute( resultList)
 get_file_report.doTitle( resultList )
 get_file_report.doBadStores(resultList)
 get_file_report.doGoodStores(resultList)
end


function get_file_report.doTitle( resultList )
 local temp
 local count

 temp = tgs.reports.filter(resultList , { { "action", actions.ops.getFile } } )
 count = tgs.reports.count( temp )

 reports.addLine(" ")
 reports.addLine("Get File Report for "..count.." Stores ")
 reports.addLine(os.date())
 reports.addLine(" ")

end

function get_file_report.doBadStores( resultList )
  local temp
  local count
  local tempString
  
  temp = tgs.reports.filter(resultList, { {"action",actions.ops.getFile},{"status",false} })
  count = tgs.reports.count(temp)
  reports.addLine("Stores for which there is get file failure "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == actions.ops.getFile) and ( m.status == false ) then
       tempString = string.format("%d   %s    tgsfile %s   mtsfile %s ",i,m.id,m.result.tgsFile, m.result.mtsFile)
       reports.addLine( tempString)
     end
   end
  end
end


function get_file_report.doGoodStores( resultList )
  local temp
  local count
  local tempString
  local fileCount

  fileCount = 0
  
  temp = tgs.reports.filter(resultList, { {"action",actions.ops.getFile},{"status",true} })
  count = tgs.reports.count(temp)
  reports.addLine("\n\nStores for which there is successful get file transfer "..count )
  for i, j in ipairs( temp ) do
   for l,m in ipairs( j ) do
     
     if  ( m.action == actions.ops.getFile) and ( m.status == true ) then
       fileCount = fileCount +1
       tempString = string.format("%d   %s    tgsfile %s   mtsfile %s ", fileCount ,m.id,m.result.tgsFile, m.result.mtsFile)
       reports.addLine( tempString)
     end
   end
  end
end





tgs.reports.addReport("GET_FILE_REPORT", get_file_report )


