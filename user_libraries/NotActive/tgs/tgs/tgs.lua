--
--
-- Overal coordination of tgs functions
--
--
--
--


path = tgsLib.path()

tgs = {}
tgs.units = {}
tgs.contact = {}
tgs.actions = {}
tgs.devices = {}
tgs.logging = {}
tgs.package = {}
tgs.results = {}

tgs.detailHelp ={}


function tgs.description()
  return "tgs package"
end

function tgs.help( item )
 if item == nil then
   print("tgs major classes ")
   print("   type .help() for more help") 
   print("tgs.contacts -- builds unit contact list  ")
   print("tgs.actions -- builds action list ")
   print("tgs.logging -- sets raw logging and email options")
   print("tgs.user_reports -- set user reports and email options")
   print("tgs.execute() -- executes tgs command sequence ")
   print("tgs.queue( description,time ) -- executes tgs command sequence at a later time")
   print("  -- time is in the form acceptable to the linux at command" )
   print("tgs.listJobs() --- list scheduled jobs  ")
   print("tgs.removeJob( jobId ) --- remove a job ")
   print("os.exit() -- terminate program from command console")
   print("")
 else
    if ( type( item ) == "string" ) and ( tgs.detailHelp[ item ] ~= nil ) then
      print( tgs.detailHelp[item ] )
    else
      print("unrecognized help option")
    end
  end

end


function tgs.execute( description )
  local returnValue
  local endTime
   
  if description == nil then description ="" end
  tgs.package = {}
  tgs.package.results = {}

  returnValue = os.time() --- time sec is the job id
 
  sqliteLog.open()
  sqliteLog.createDb()

  tgs.package.chain, tgs.package.units = contacts.getUnitList()
  tgs.package.actions =  actions.getActionList()
  tgs.devices.listExecute( tgs.package.results, tgs.package.actions, tgs.package.chain, tgs.package.units )

 
  endTime = os.time()
  

 

  tgs.logging.dumpOutput( returnValue, tgs.package.results )
  tgs.output = {}
  tgs.reports.execute( tgs.output, user_reports.get(), tgs.package.results )
  
  tgs.user_reports.dumpOutput( jobId, tgs.output)

--
--
--
--
--

  sqliteLog.createJob( returnValue, description, returnValue, endTime )

  tgs.logging.dataBaseLog( returnValue, tgs.package.results )

  sqliteLog.close()

  return returnValue
end

function tgs.queue( description, time )
  local pickleString
  local jobId
  local fileName
  local package
  local output
  local pickleTemp
  

   jobId,pickleString = tgs.generatePickleString( description )
   pickleTemp = base64.encode( pickleString )
   sqliteLog.open()
   sqliteLog.createDb()
   sqliteLog.logPickleData( jobId, pickleTemp )
   sqliteLog.close()
    --- 
    ---
    --- Generate batch file
    ---
    --- 
    print("jobId",jobId)
    output = io.open("batchFile","w")
    output:write("#!/bin/bash \n")
    output:write("./tgs tgsBatch.lua "..jobId.." 2>&1  >"..jobId..".txt \n") 
    output:close()
    ---
    --- Generate batch file
    ---
    ---
     os.execute("at -f batchFile".."  "..time )
 --    os.remove("batchFile")
    printf("job %s queued for %s time ",jobId,time)
end

function tgs.generatePickleString( description )
  local pickleString
  local jobId
  local fileName
  local package
 

   package = {}
   package.description = description
   package.jobId = os.time()
    
   package.chain, package.units = contacts.getUnitList()
   package.actions               =  actions.getActionList()

   package.logging               = {}
   package.logging.emailFlag     = tgs.logging.emailFlag
   package.logging.fromUser      = tgs.logging.fromUser
   package.logging.toUser        = tgs.logging.toUser
   package.logging.address       = tgs.logging.address
   package.logging.port          = tgs.logging.port
   package.logging.level         = tgs.logging.level 
   package.logging.output        = tgs.logging.output

   package.user_reports               = {}
   package.user_reports.emailFlag     = tgs.user_reports.emailFlag
   package.user_reports.fromUser      = tgs.user_reports.fromUser
   package.user_reports.toUser        = tgs.user_reports.toUser
   package.user_reports.address       = tgs.user_reports.address
   package.user_reports.port          = tgs.user_reports.port
   package.user_reports.level         = tgs.user_reports.level 
   package.user_reports.output        = tgs.user_reports.output
   package.user_reports.reportList       = tgs.user_reports.reportList

   pickleString = xmlUtil.pickle( package )
   return package.jobId, pickleString
end

function tgs.executePickleString( pickleString )
  local jobId
  local endTime
  local package
  local results
  local description
  
  
 
  package = xmlUtil.unpickle( pickleString )
  jobId = os.time() --- time sec is the job id

  description = package.description
  if description == nil then description = "" end

  sqliteLog.open()
  sqliteLog.createDb()
  
  package.results = {}
  devices.listExecute( package.results, package.actions, package.chain, package.units )

  endTime = os.time()

 
  for i,j in pairs( package.logging) do
     tgs.logging[i] = j
  end 

  for i, j in pairs( package.user_reports) do 
    tgs.user_reports[i] = j
   end

  tgs.logging.dumpOutput( jobId, package.results )
  tgs.output = {}
  tgs.reports.execute( tgs.output, user_reports.get(), package.results )
  
  tgs.user_reports.dumpOutput( jobId, tgs.output)


  sqliteLog.createJob( jobId, description, jobId, endTime )

  tgs.logging.dataBaseLog( jobId, package.results )

 
  sqliteLog.close()
  return jobId
end


function tgs.getPickleString( jobId )

  local pickleString

  sqliteLog.open()
  sqliteLog.createDb()

  -- get pickle string

  sqliteLog.close()
  return pickleString
end



function tgs.listJobs()
  print("list of jobs which are queued")
  os.execute("atq ")
  print("end of jobs queued")
end

function tgs.removeJob( jobId )
  print("removing jobid ",jobId)
  os.execute("atrm ".. jobId )
  print("remaining jobs ")
  os.execute("atq")
  print("end of remaining jobs")
end

----
----
----
---- detailed help
----
----
----
----



tgs.detailHelp["execute"] =
[[
    tgs.execute.() -- executes command sequence
                  

]]

tgs.detailHelp["queue"] =
[[
    tgs.queue(description, time ) -- queues a job for execution at a later time
    description -- text description of the job
    time - time is in the form acceptable to the linux at command

]]
  
tgs.detailHelp["listJobs"] =
[[
  tgs.listJobs() -- list scheduled jobs for at command

]]

tgs.detailHelp["removeJob"] =
[[

  tgs.removeJob( jobId )  --- remove a scheduled job

]]

   
