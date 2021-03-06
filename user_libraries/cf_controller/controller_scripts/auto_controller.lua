---
---
--- File: auto_controller.lua
---
---
---
---
---
---
---
---

cf_auto_controller = {}
cf_auto_controller.wday = 0
cf_auto_controller.hour = 0
cf_auto_controller.min = 0
cf_auto_controller.dailyScript = nil -- filled in by initialization
cf_auto_controller.hourScript = nil
cf_auto_controller.minuteScript = nil

function cf_auto_controller.initialize()
  local temp
  cf_auto_controller.executeTableSequence( cf_auto_controller.dailyScript )
  cf_auto_controller.executeTableSequence( cf_auto_controller.hourScript )
  cf_auto_controller.executeTableSequence(cf_auto_controller.minuteScript )
  temp = os.date("*t")
  cf_auto_controller.wday = temp.wday
  cf_auto_controller.hour = temp.hour
  cf_auto_controller.min = temp.min
end


function cf_auto_controller.masterPoll()
  local temp
  temp = os.date("*t")
  if temp.wday ~= cf_auto_controller.wday then cf_auto_controller.executeTableSequence( cf_auto_controller.dailyScript ) end
  if temp.hour ~= cf_auto_controller.hour then cf_auto_controller.executeTableSequence( cf_auto_controller.hourScript ) end
  if temp.min ~= cf_auto_controller.min then cf_auto_controller.executeTableSequence( cf_auto_controller.minuteScript ) end
  cf_auto_controller.wday = temp.wday
  cf_auto_controller.hour = temp.hour
  cf_auto_controller.min = temp.min
end


function cf_auto_controller.executeTableSequence( script )
 print("Executing script")
end

  