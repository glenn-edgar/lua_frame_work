---
---
--- lua pattern / lua string buffer higher functionality
---
---
---



function patStr.createArray( number_of_pat_buffers )
  local returnValue, temp
  returnValue = {}
  for i = 1, number_of_pat_buffers do
    temp = patStr.createObject( 0 ) -- no attached storage
    table.insert( returnValue,temp);
  end
  return returnValue
end

function patStr.freeArray( patArray)
   local returnValue, temp 

   temp = table.remove (patArray)
   while temp ~= nil do
     patStr.terminate(temp)
     temp.remove(patArray)
   end
   patArray = nil
end
      
 

function patStr.split( referencePat, patArray, splitString )
  local tempElement
  local count
  local tempPat
  local temp
 
  tempPat = referencePat
  count = 1
  tempElement = patArray[count]
  while tempElement ~= nil do
    
 
    temp = patStr.find(tempPat.patString, splitString, 0) 
    if temp < 0 then
      patStr.copy( tempElement.patString, tempPat.patString, 0 ,-1)
      tempElement = nil
    else
      patStr.copy( tempElement.patString, tempPat.patString,0,temp-1)
      patStr.findAndAdvance(tempPat.patString, splitString, 0 ) 
      count = count +1
      tempElement = patArray[count]
 
   end
  
 end
 patBuf.reset(referencePat)
 return count

end



