---
--- File: lua_reports.lua
---
---
---
---
---

reports = {}
reports.reportList = {}
reports.detailHelp = {}

function reports.description()
  return "tgs report manager"
end


function reports.help(item)
 if item == nil then
   print("tgs.reports.listReports() --- list register reports")
   -- print(".addReport( reportName ) " )
   -- print(".execute( output, reportLists, results  )") 
   print("tgs.reports..setEmail( fromUser, toUser, subject, address, port ) ")
   print("            -- configure email account               ")
   print("tgs.reports.setTerminalOutput() -- contact report is sent to terminal")
   print("tgs.reports.setFileOutput( fileName ) -- contact report is sent to specified file") 
 else
   if ( type( item ) == "string" ) and ( reports.detailHelp[ item ] ~= nil ) then
      print( reports.detailHelp[item ] )
    else
      print("unrecognized help option")
    end
 end
end



function reports.listReports()
  local temp
  print("currently registered reports")
  temp = ts.sort( reports.reportList )
  for i,k in ipairs( temp ) do
    print(k)
  end
end





function reports.addReport( name, reportObject )
  reports.reportList[ name] = reportObject
end




--
--
-- execute actions for a single unit
--
--
function reports.execute( output, reportList, result )
  local reportObject

  reports.output = output -- list to append report data
  for i,j in ipairs( reportList ) do
   reportObject = reports.reportList[ j ]
   reportObject.execute( result )
  end
  reports.output = nil
end   

 

function reports.addLine( line)
  table.insert(reports.output,line ) 
end


function reports.testFilter( element, filter )
  local returnValue
  local temp
  for i,j in ipairs( filter ) do 
    temp = element[ j[1] ] 
    if temp ~= j[2] then return false end
  end 
  return true -- all tests passed
end  

function reports.filterA( returnValue,results_a,filter)
  for l,m in ipairs( results_a ) do
     if reports.testFilter( m, filter ) then
      table.insert( returnValue, results_a)
      return 
     end
   end
   return
end


function reports.filter( result, filter )
  local returnValue
  
  returnValue = {}
  for i,j in ipairs( result ) do
    reports.filterA( returnValue,  j, filter )
  end
  return returnValue
end


function reports.count( entries )
  local counts
  counts = 0
  for i,j in pairs( entries ) do
   counts = counts +1
  end
  return counts
end

function reports.checkReport( reportEntry )
  ts.dump( reportEntry )
  assert( reports.reportList[ reportEntry ] ~= nil , "report "..reportEntry .. "  is not registered ")
end


reports.detailHelp["listReports"] =
[[
tgs.reports.listReports() -- list reports which have been registered
              

]]


reports.detailHelp["setEmail"] =
[[
    tgs.logging.setEmail( fromUser, toUser, subject, address, port )
                      -- configure email account
		      -- fromUser must be a valid email address
                     
]]


reports.detailHelp["setTerminalOutput"] =
[[
    tgs.logging.setTerminalOutput() -- directs report output to terminal
        
                     
]]

reports.detailHelp["setFileOutput"] =
[[
    tgs.reports.setFileOutput( fileName )
                      -- directs report output to fileName
                     
]]




tgs.reports = reports














