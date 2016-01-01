--[[
     File: txdControl.lua
     Manages txd files
--]]


txdControl = {}

function addTxdTable( name, fileName, fieldDescription)
 fieldDescription.fileName = fileName
 if validateFields( fieldDescription)   then
   txdControl[ name ] = fieldDescription
 end
end

function validateFields( fields )
  if fields.fileName == nil then return assert(0) end
  if type(fields) ~= "table" then return assert(0) end
  if fields.skipLine == nil then return assert(0) end
  if fields.lineCnt  == nil then return assert(0) end
  if fields.fieldList == nil then return assert(0) end
  if fields.fieldDesc == nil then return assert(0) end
  -- do other checks as warrented
  return true
end

----
----
----
---- Parsing Txd's
----
----
----


function loadtxd( fileName )
 local returnValue; 
 local fileList;
 local txdfileName;
 local fileList;
 local fileControl;
 local temp;
 local j;
 local startIndex;
 local endIndex;
 local key;


 returnValue = {}
 fileControl = txdControl[ fileName ]
 
 if fileControl == nil then return returnValue end;
 txdfileName = "data/".. fileControl.fileName..".txd"
 
 fileList = findFileList( txdfileName );

 j = 1;

 
 startIndex = fileControl.skipLine +1
 if fileControl.lineCnt == 0 then 
    endIndex = #fileList
 else
    endIndex = startIndex + fileControl.lineCnt -1 
 end 


 for i = startIndex, endIndex do
    
 if fileControl.lineCnt ~= 0 then
     returnValue = parseTxd(fileControl,fileList[i] );
 else
   
     temp,key = parseTxd( fileControl, fileList[i]); 
     if temp == nil then break end
     temp.key = key 
     if temp[ key ] == nil then
         temp[key] = j;
        
     end
     returnValue[  j] = temp;
     j = j+1;
 end
 
 
  end
 returnValue =  generateKeyField( fileControl, returnValue )
 returnValue = generateNumber( fileControl, returnValue )
 
 return returnValue;
end



function findFileList( fileName )
  local returnValue
  local tempFile

  returnValue = {}
  tempFile = io.open(fileName,"r")
 
  if tempFile == nil then return returnValue end

  for line in tempFile:lines() 
  do 
     table.insert (returnValue, line)
     
  end
  tempFile:close()
  return returnValue

end


function parseTxd( fileControl, fileLine )
  local rawFields
  local rawTemp;
  local returnValue;
  
  if type(fileLine) ~= "string" then return nil end
  
  rawFields = string.ssplit( fileLine,"|")
 
  
  if #rawFields < 2 then 
   rawFields[1] = string.trim( rawFields[1] )
   if rawFields[1] == "" then return nil end
  end
  for i, j in ipairs( rawFields ) do
    rawFields[i] = string.trim(j);
  end
  for i,j in ipairs( rawFields) do
   
    if fileControl.fieldDesc[i] == 'i' then
     rawFields[i] = tonumber( rawFields[i] )
    end
    if fileControl.fieldDesc[i] == 'n' then
     rawFields[i] = ""
    end

   
   if type(fileControl.fieldDesc[i]) == "function" then

     rawFields[i] = fileControl.fieldDesc[i]( 0, fileControl, rawFields, rawFields[i] )
   end
  end
  rawTemp = {}
  for i, j in ipairs( fileControl.fieldList ) do
    rawTemp[j] = rawFields[i]
  end

 
 return  rawTemp, fileControl.key
end

----
----
----
---- storing Txd's
----
----
----

function storetxd( fileName, webData )
 local returnValue; 
 local fileList;
 local txdfileName;
 local fileList;
 local fileControl;
 local temp;
 local startIndex;
 local endIndex;

 returnValue = {}
 fileControl = txdControl[ fileName ]

 if fileControl == nil then return returnValue end;
 txdfileName = "data/".. fileControl.fileName..".txd"

 fileList = findFileList( txdfileName );



 startIndex = fileControl.skipLine +1
 if fileControl.lineCnt == 0 then 
    endIndex = #fileList
 else
    endIndex = startIndex + fileControl.lineCnt -1 
 end 

 
 
 nullFileList( fileList, startIndex,endIndex);

  
  if fileControl.lineCnt == 0 then
   
   for i,j in ipairs( webData ) do
   
    if j ~= "" then
      fileList[startIndex] = assembleElement( fileControl, j )
      startIndex = startIndex + 1;
    end
   end
   
 else
  if webData[1] ~= "" then
    fileList[startIndex] = assembleElement( fileControl, webData[1] )
  end 
 end
 
 storeFileList( fileName, txdfileName, fileList)
 

end
 


function nullFileList( fileList, startIndex,endIndex )
 
   for i = startIndex, endIndex do
    fileList[i] = nil
   end
end


function generateTxdHeader( fileName )
  local returnValue

  returnValue = "null|"..fileName..".txd|"..gm_date().."|"..gm_date()

  return returnValue
end


function modifyTxdHeader( fileName, line_1)
  local temp
  local returnValue
  temp = string.ssplit(line_1,"|")
  if temp[1] == nil then temp[1] = "null" end
  temp2 = fileName..".txd"
  if temp[3 ] == nil then temp[3] = "null" end
  temp[4] = gm_date()
  returnValue = table.concat(temp,"|")
  return returnValue
end

function storeFileList( fileName, txdFileName,fileList)
  local returnValue
  local tempFile
  local line;

  returnValue = {}
  tempFile = io.open(txdFileName,"w")
  
  if tempFile == nil then return returnValue end

  if fileList[1] == nil then 
    fileList[1] = generateTxdHeader(fileName)
  else
    fileList[1] = modifyTxdHeader(fileName, fileList[1] )
  end
  if fileList[2] == nil then fileList[2] = " " end
  if fileList[3] == nil then fileList[3] = " " end
  if fileList[4] == nil then fileList[4] = " " end
  if fileList[5] == nil then fileList[5] = " " end
  --ts.dump(fileList)
  for i,line in ipairs(fileList) do
 
     tempFile:write(line,"\n");
     
  end
  tempFile:close()
  return returnValue

end

function assembleElement( fileControl, webData )
  local tempList
  local k
  local temp
  
   k= 1
   tempList = {}
  for i, j in ipairs( fileControl.fieldList ) do
  
   if webData[j] == nil then webData[j] = "" end
   if j ~= "blank" then
    
    tempList[i] = webData[j]
    
   end
  
  end
  --ts.dump(webData)
 -- ts.dump(fileControl.fieldList)
 -- ts.dump(tempList)

 for i,j in ipairs( fileControl.fieldDesc ) do
    
    if j == 'i' then
     tempList[i] = tonumber( tempList[i] )
   end
    if j == 'n' then
      tempList[i] = ""
    end
   if type(j) == "function" then
     tempList[i] = j( 1, fileControl, tempList, tempList[i] )
   end
  end
  temp = {}
  for i,j in ipairs( fileControl.fieldDesc ) do
    if j ~= "blank" then
     temp[k] = tempList[i]
     k= k+1;
    end
  end
 
 
 return concatData( temp );

end


function concatData( tempList )
 local returnValue;

 returnValue = ""
 for i = 1 , #tempList   do
    tempList[i] = booleanFilter( tempList[i] )
    if tempList[i] == nil then tempList[i] = "" end
    if i < #tempList then
      returnValue = returnValue .. tempList[i] .."|"
    else
      returnValue = returnValue .. tempList[i]
    end
 end
 return returnValue
end

function booleanFilter( entry )
  if type(entry) == "boolean" then
   if entry == true then
     entry = 1
   else 
     entry = 0
   end
  end
  return entry
end 




function generateKeyField( fileControl, fileList )
  if fileControl.key == nil then return fileList end
  for i ,j in ipairs( fileList ) do
    j.key = fileControl.key
  end
  return fileList;
end 
 

function generateNumber( fileControl, fileList )
  if fileControl.generateNumber == nil then return fileList end
  for i,j in ipairs( fileList ) do
    j.number = i
  end
  return fileList
end




function gm_date()
   local temp
   local returnValue
   local monthMap = { "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC" }
   temp = os.date("!*t")
   returnValue = temp.day.." "..monthMap[temp.month].." "..temp.year.." "..temp.hour..":"..temp.min..":"..temp.sec
   return returnValue
end
