--
-- File: appEvents.lua
-- This lua file manages application events
--    1. insures that application events have a unique id
--    2. maintains a list of register events
--
--
--
--

appEvents = {}


appEvents.dictionary = {}


function appEvents.addEvent( eventName, eventDescription )
  local temp
  local id

   
  temp                  = {}
  temp.eventName        = eventName
  temp.eventDescription = eventDescription
   
  appEvents.dictionary[ eventName ] = temp

end

function appEvents.removeEvent( eventName )

   appEvents.dictionary[ eventName ] = nil

end


function appEvents.listEvents()
  local i,j
  print("list of application events")
  for i,j in pairs( appEvents.dicionary ) do
   printf(" event name: %s",i )
  end

end


function appEvents.description()
  return "registers application events"
end

function appEvents.help()
 print("appEvents.addEvent( eventName,eventDescription )  -- adds app event")
 print("appEvents.removeEvent(eventName )                 -- removes app events")
 print("appEvents.listEvents()                            -- list registered app events")
end
