---
---
---
--- file: xmlToTable.lua
--- The purpose of this file is to transform an xml definition
--- into a lua table frame work
---
---
---
---
---



xmlUtil = {}
xmlUtil.stackTable = {}
xmlUtil.localTable = {}
function  xmlUtil.processStartElement(parser, elementName, attributes)
       local temp = {}
       if xmlUtil.localTable ~= nil then
          xmlUtil.localTable.elements[elementName] = temp
          table.insert( xmlUtil.stackTable, xmlUtil.localTable )
       end
       xmlUtil.localTable = temp
       xmlUtil.localTable.elements = {}
       xmlUtil.localTable.name = elementName
       xmlUtil.localTable.attributes = {}
       for i ,k in pairs(attributes) do -- add in elements
         if (type(i) == "string") then
           xmlUtil.localTable.attributes[i] = k
         end
       end 
      

end


function xmlUtil.processEndElement( parser, elementName)
    local temp
    temp = table.remove(xmlUtil.stackTable) -- pop name off of stack
    if temp ~= nil then
      xmlUtil.localTable = temp
    end
  
end



xmlUtil.callbacks = {
    StartElement = xmlUtil.processStartElement,
    
    EndElement = xmlUtil.processEndElement
}

function xmlUtil.fileToTable( fileName )
  local l
  local p

  xmlUtil.localTable = nil
   
  p = lxp.new(xmlUtil.callbacks)
  for l in io.lines( fileName ) do  -- iterate lines
    p:parse(l)          -- parses the line
    p:parse("\n")       -- parses the end of line
  end

  p:parse()               -- finishes the document
  p:close()               -- closes the parser

  return xmlUtil.localTable
end


function xmlUtil.stringToTable( xmlString )

  local p
  xmlUtil.localTable = nil
   
  p = lxp.new(xmlUtil.callbacks)
  p:parse(xmlString)


  p:parse()               -- finishes the document
  p:close()               -- closes the parser

  return xmlUtil.localTable
end


function xmlUtil.url_decode(str)
  str = tostring(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end



 function xmlUtil.url_encode(str)
    str = tostring(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
            function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str	
  end



function xmlUtil.xmlTableToString( table, xmlString )
    if xmlString == nil then xmlString = "" end
    
    xmlString = xmlString .. "<" .. table.name .. " "
   
    for i,k in pairs( table.attributes ) do
      xmlString = xmlString ..i..'="'..k..'" '
    end
    xmlString = xmlString .. " > "
     for i,k in pairs( table.elements ) do
      xmlString =xmlUtil.xmlTableToString( k, xmlString)
    end
    xmlString = xmlString .. "</" .. table.name .. "> "
    return xmlString
    
end


function xmlUtil.tableToXMLTable( name, xmlTable )
   local temp
   
   temp = {}
   temp.name = name
   temp.elements = {}
   temp.attributes = {}
  
   for i, j in pairs( xmlTable ) do
      
      if  type(j) == "table" then
        i = xmlUtil.encodeIndex(i)
        temp.elements[i] = xmlUtil.tableToXMLTable( i,j )
      else
        i = xmlUtil.encodeData(i, j)
        if type(j) == "number" then
          temp.attributes[ i ] = xmlUtil.url_encode( tostring(j) )
        elseif type(j) == "function" then
          temp.attributes[ i ] = xmlUtil.url_encode( string.dump(j) )
        else
           temp.attributes[ i ] = xmlUtil.url_encode( j )
        end
     end
   end
   return temp
end

function xmlUtil.XMLTableToTable( xmlTable )
  local ii,jj
  local temp
 
  temp = {}
   
  for i,j in pairs( xmlTable.attributes ) do
    ii,jj = xmlUtil.decodeData(i,j)
    temp[ii] = jj
  end
  for i,j in pairs( xmlTable.elements ) do
    ii = xmlUtil.decodeIndex(i)
    temp[ii] = xmlUtil.XMLTableToTable(  j)
  end
  return temp
end


function xmlUtil.pickle( name, table )
 local temp
 temp = {}

  if type(name) == "table" then table = name name = "temp" end
  temp = xmlUtil.tableToXMLTable( name,table)
  return xmlUtil.xmlTableToString( temp )

end

function xmlUtil.unpickle( xmlString )
  local temp
 
  temp =  xmlUtil.stringToTable( xmlString )
  
  return xmlUtil.XMLTableToTable( temp)
end


function xmlUtil.help()
  print("function members for xmlUtil package")
  print("")
  print(".fileToTable(fileName) -- converts xml file to hiearachical table ")
  print(".stringToTable( string) -- converts xml string to hiearchical table")
  print(".pickle( name,table ) --- returns xml string ")
  print(".unpickle( xmlString) -- returns table ")
  print(".help() -- list functions in this package")
  print("")
end

function xmlUtil.description()
  return "xml support for lua tables"
end

function xmlUtil.encodeIndex(i)
 local returnValue
   if type(i) == "string" then
    returnValue = "S"..i
  else
   returnValue = "N"..i
  end
  return returnValue
end

function xmlUtil.encodeData(i, j)
  local returnValue
  returnValue = xmlUtil.encodeIndex(i)
  if type(j) == "number" then
    returnValue = "N"..returnValue
  elseif type(j) == "function" then
    returnValue = "F"..returnValue
  else
    returnValue = "S"..returnValue
  end
    return returnValue
end


function xmlUtil.decodeIndex(i)
  local returnValue
  local typeChar

  typeChar = string.sub(i,1,1)
  returnValue = string.sub(i,2)

  if typeChar == "N" then
    returnValue = tonumber(returnValue)
  else
   assert(typeChar =="S","bad xml encoding")
  end
  return returnValue
end


function xmlUtil.decodeData(i,j)
  local returnValue1
  local returnValue2
  local dataType
  local temp
  
  dataType = string.sub(i,1,1)
  temp = string.sub(i,2)
  returnValue1 =  xmlUtil.decodeIndex(temp)
  j = xmlUtil.url_decode(j)
  returnValue2 = j
  if dataType == "N" then
    returnValue2 = tonumber(j)
  elseif dataType == "F" then
    returnValue2 =  assert(loadstring(j))
  else
    assert(dataType == "S","bad xml encoding")
  end
  return returnValue1, returnValue2
end
  

