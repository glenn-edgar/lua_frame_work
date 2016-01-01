--
--
-- File: to load lua scripts at runtime
--
--
--
local line
local path

path = "start_up_scripts/"

for line in io.lines(path.."init.dat" ) do
-- line = string.trim(line)
 dofile(path..line)
end
 
