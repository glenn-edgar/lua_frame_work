--[[
     file compile.lua
     This code is a slight repackage of lua.lua in the 
     lua distribution
--]]


function compile( infile, outfile )
  f = assert(io.open(outfile,"wb"))
  f:write( string.dump( assert(loadfile(infile))))
  io.close(f)
end


