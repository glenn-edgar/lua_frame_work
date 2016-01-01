--[[

    enhanced_string.lua
    The purpose of this file is to augment the string package.
    
    




--]]



function sprintf(fmt,...)
  return string.format(fmt,unpack(arg))
end

function printf(fmt, ... )
  print( string.format(fmt,unpack(arg)) )
end


-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter ( which may be a pattern ).
-- example: string.split(",%s*","
function string.trim(s)
  return( string.gsub(s,"^%s*(.-)%s*$","%1"))
end


--
--  Code is from lua wiki
--
-- [first] begin dump at 16 byte-aligned offset containing 'first' byte
-- [last] end dump at 16 byte-aligned offset containing 'last' byte
function string.hex_dump(buf,first,last)
      local function align(n) return math.ceil(n/16) * 16 end
      for i=(align((first or 1)-16)+1),align(math.min(last or #buf,#buf)) do
         if (i-1) % 16 == 0 then io.write(string.format('%08X  ', i-1)) end
         io.write( i > #buf and '   ' or string.format('%02X ', buf:byte(i)) )
         if i %  8 == 0 then io.write(' ') end
         if i % 16 == 0 then io.write( buf:sub(i-16+1, i):gsub('%c','.'), '\n' ) end
       end
end


