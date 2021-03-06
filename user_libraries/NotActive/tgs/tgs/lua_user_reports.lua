---
---
--- file: lua_user_reports.lua
---
---
---
---
---


user_reports = {}
user_reports.reportList = {}
user_reports.detailHelp = {}

function user_reports.clear()
  user_reports.reportList = {}
end

function user_reports.list()
 print("user reports ")
 for i,j in ipairs( user_reports.reportList ) do
   print(i,j )
 end
end

function user_reports.get()
  return user_reports.reportList
end

function user_reports.add( report )
  if type(report) == "table" then
    for i,j in ipairs(report) do
      tgs.reports.checkReport(report)
      table.insert( user_report.reportList,report )
    end
  else
    tgs.reports.checkReport( report )
    table.insert( user_reports.reportList, report )
  end
end

function user_reports.setEmail( fromUser, toUser, subject, address, port )

user_reports.emailFlag = true
user_reports.from = fromUser
user_reports.to  = toUser
user_reports.subject = subject
user_reports.address = address
user_reports.port = port

end



function user_reports.setTerminalOutput()

logging.output = nil

end

---
---
--- sets to file
---
---


function user_reports.setFileOutput( fileName )

user_reports.output = fileName


end

function user_reports.dumpOutput( jobId, results )
  local temp
  local x
  temp = user_reports.toString( jobId, results )
  if user_reports.output ~= nil then
   x = io.open( user_reports.output, "w+" )
   if x ~= nil then
     x:write( temp)
     x:close(x)
   else
     print(temp)
   end 

  else
   print( temp )
  end
  if user_reports.emailFlag == true then
    if type( user_reports.to) == "table" then
       for i,j in ipairs( user_reports.to ) do
         smtp.send( user_reports.from, j, user_reports.subject, temp , user_reports.address , user_reports.port) 
       end   
    else
       smtp.send( user_reports.from, user_reports.to, user_reports.subject, temp , user_reports.address , user_reports.port)
    end
  end
  temp = nil
end


function user_reports.description()
  return "generates and configure user reports"
end

function user_reports.help()
   if item == nil then
     print("tgs.user_reports.clear()        --- clears generation reports ")
     print("tgs.user_reports.add( report )  --- adds a report             ")
     print("tgs.user_reports.list()         --- lists added reports       ")
     print("tgs.user_reports.setEmail( fromUser, toUser, subject, address, port ) ")
     print("            -- configure email account               ")
     print("tgs.user_reports.setTerminalOutput() -- contact report is sent to terminal")
     print("tgs.user_reports.setFileOutput( fileName ) -- contact report is sent to specified file")
 
   else
    if ( type( item ) == "string" ) and ( user_reports.detailHelp[ item ] ~= nil ) then
      print( user_reports.detailHelp[item ] )
    else
      print("unrecognized help option")
    end
  end
 
end

---
--- Internal string functions
---
---print(temp)

function user_reports.toString( jobId, results)
  local returnValue
  returnValue = table.concat(results,"\n")
  return returnValue
end

---
---
--- detailed help
---
---
---

user_reports.detailHelp["clear"] =
[[
    user_reports.clear()        --- clears generation reports
                  

]]

user_reports.detailHelp["add"] =
[[
   user_reports.add( report )  --- adds a report 
                  

]]

user_reports.detailHelp["list"] =
[[
    user_reports.list()         --- lists added reports
                  

]]

user_reports.detailHelp["setEmail"] =
[[
   user_reports.setEmail( fromUser, toUser, subject, address, port ) 
                        -- configure email account          

]]

user_reports.detailHelp["setTerminalOutput"] =
[[
  user_reports.setTerminalOutput() -- contact report is sent to terminal

]]

user_reports.detailHelp["setFileOutput"] =
[[
   user_reports.setFileOutput( fileName ) -- contact report is sent to specified file


]]



tgs.user_reports = user_reports


