function dumpExtensions()
  local temp
  local k
  temp = {}
  print("")
  for i,k in pairs(_G) do
   if (type(k) == "table") and (k.help ~= nil ) and (type(k.help) == "function") then
    temp[i]=k
   end
  end
  temp = ts.sort(temp)
  for i,j in ipairs(temp) do 
    k = _G[j]
    if (k.description ~= nil) and (type(k.description) == "function" ) then
      print(j,"",k.description())
    else
      print(j)
    end
  end
  print("\nAccess the .help() method for further details\n")
end 


