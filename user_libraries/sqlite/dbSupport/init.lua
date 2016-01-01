---
---
--- File: to sequence db support files
---
---
--- 

dbCtl = {}
dbCtl.helpData = {}

function dbCtl.help()
  local i,k
  print("help commands for dbCtl")
  for i,k in ipairs( dbCtl.helpData) do
    printf(".%s  -- %s",k[1],k[2] )
  end
end


