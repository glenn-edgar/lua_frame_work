---- master event list
----
----

---
---
--- System Events
---
---
---
masterEventList = {}
masterEventList.threadTermination = 1
masterEventList.localEvent        = 2
masterEventList.reset             = 3
masterEventList.offLine           = 4
masterEventList.onLine            = 5


masterEventList.wdRequest = 100  -- no data
masterEventList.wdReply   = 101  -- data is queue
masterEventList.wdAdd     = 102  -- data is [ queue , time in seconds ]
masterEventList.wdRemove  = 103  -- data is queue

masterEventList.todSec    = 200  -- data is the second
masterEventList.todMinute = 201  -- data is the minute
masterEventList.todHour   = 202  -- data is the hour
masterEventList.todDay    = 203  -- data is the day
masterEventList.todAdd    = 204  -- data is list with following parameters
                                 -- { tod_key, time (sec), max time (sec) ,
                                 --   event}
masterEventList.todRemove = 205  -- data is unique id

masterEventList.timeTick = 300 -- time Tick of polling loop
--- zigbee Events start from 0x5000


