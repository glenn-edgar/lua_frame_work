--
--
-- File: to load lua scripts at runtime
--
--
--
local line
local path


for line in io.lines(path.."/init.dat" ) do
 line = string.trim(line)
 dofile(path..line)
end
 
