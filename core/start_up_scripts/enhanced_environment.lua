---
--- File :enchanced_environment.lua
--- Functions take from 
--- Programming in Lua -- second editon
--- Chapter 14 The Environment
--- page 130


env = {}

function env.getfield( f )
  local w
  local v = _G            -- start with the table of globals
  for w in string.gmatch( f, "[%w_]+") do
    if type(v) ~= "table" then return nil end
    v = v[w]
  end
  return v
end



function env.setfield( f, v )
   local d,w
   local t = _G          -- start with the table of globals
   for w, d in string.gmatch(f,"([%w_]+)(.?)") do
    if d == "." then     -- not last field
      t[w] = t[w] or {}  -- create table if absent
      t = t[w]           -- get the table
    else                 -- else last field
      t[w] = v           -- do the assignment
    end
   end
end
 

function env.help()
 print("env allows creation of global packages and fields")
 print(".getfield( 'f.g.x') -- retrieves value ")
 print(".setfield( 'f.g.x',data) -- sets value and creates structures if not present")
end

function env.description()
  return "env allows creation of global packages and fields"
end