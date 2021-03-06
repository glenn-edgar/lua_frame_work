--[[
File: web.lua
The purpose of this file is to implement the mongoose bindings that are done in lua


--]]


---
---
---
---
---



web.uri_dispatch_table = {}
web.file_up_load_table = {}




function web.set_dynamic_uri( uri, uri_function )
  web.uri_dispatch_table[uri] = uri_function
end

function web.clear_dynamic_uri_table()
  web.uri_dispatch_table = {}
  web.file_up_load_table = {}
end




function web_access()
  local uri
  local uri_function;
  uri = web.getUri()
  uri_function = web.uri_dispatch_table[ uri ]
  print("uri",uri,"uri_function",uri_function)
  if uri_function ~= nil then
    uri_function()
    web.storeReturnCode(web.uri_dispatch_table)
  else
    web.storeReturnCode(nil)
  end
  
end


function web.register_file_upload( uri, size,directory, reportFunction )
  local entry
  entry = {}
  entry.size = size
  entry.directory = directory
  entry.reportFunction = reportFunction
  web.file_up_load_table[uri] = entry
  web.set_dynamic_uri(uri,web.file_upload)
end  


function web.file_upload(  )
  local directory
  local size
  local entry
  local postHandle
  local postDataLength
  local postBuffer
  local tmp

  uri = web.getUri()
  entry = web.uri_up_load_table[ uri]
  if entry ~= nil then
    size = entry.size
    directory = entry.directory
    postHandle = strBuf.create( size)
    postBuffer, tmp = strBuf.getBuffer( postHandle)   
    postDataLength = web.getPostData(postBuffer,length)
    error,fileName = web.file_upload( postDataLength, postBuffer, directory)
    if entry.reportFunction ~= nil then
      entry.reportFunction(error,fileName )
    end 
    strBuf.terminate(postHandle)
  end  

end



---
--- return/status  200 ok
--- redirect       302 found 
---
---
function web.headerStart( returnCode, status )
  web.dump("HTTP/1.1 "..returnCode.." "..status.."\r\n")
  web.dump("Cache: no-cache\r\n")

end

--[[
    Typical Content Types



  application/json
  application/javascript
  application/octet-stream  -- Arbitrary binary data
  application/soap+xml
  application/xhtml+xml
  application/xml-dtd
  application/zip
  text/cmd:   -- commands; subtype resident in Gecko browsers like FireFox 3.5
  text/css
  text/csv
  text/html
  text/plain
  text/xml

]]--


function web.addContent( contentType )
  web.dump("Content-Type: "..contentType.."\r\n")
end

function web.addCookie( key,value)
  web.dump("Set-Cookie: "..key.."="..value.."\r\n")
end

--
-- Used in 302 measurements
--
--
--
function web.location( location )
  web.dump("Location: "..location )
end


function web.headerEnd()
  web.dump("\r\n")
end






-- ports of the form "80,443s" note s suffix is sucure port
function web.set_listening_port(ports)
  web.setOption("listening_ports",ports)
end

-- document root is of the form "/xxx" 
function web.set_document_root( document_root)
  web.setOption("document_root",document_root)
end


function web.set_password_file(password_file)
   web.setOption("htpasswd_file",password_file)
end

--- ".cgi,.pl,.php"
function web.set_cgi_extensions( cgi_extensions)
  web.setOption("cgi_extensions",cgi_extensions)
end

---- like this: "VARIABLE1=VALUE1,VARIABLE2=VALUE2". Default: ""
function web.cgi_environment(values)
   web.setOption("cgi_environment",values)
end   
 
---- This must be specified if PUT or DELETE methods are used. Default: ""
function web.put_delete_passwords_file(value)
  web.setOption("put_delete_passwords_file",value)
end

--- Default: "mydomain.com"
function web.authentication_domain(domain)
  web.setOption("authentication_domain",domain)
end

--- Default: "shtml,shtm" 
--- Currently, two SSI directives supported, "include" and "exec"
function web.ssi_extensions( extensions)
  web.setOption("ssi_extensions",extensions)
end

--- Default: "", no logging is done.
function web.access_log_file(log_file) 
  web.setOption("access_log_file",log_file)
end

--- Default: "", no errors are logged.
function web.error_log_file( log_file)
  web.setOption("error_log_file",log_file)
end

--- Default: ""
function web.global_passwords_file( password_file)
  web.setOption("global_passwords_file",password_file)
end

-- Default: "index.html,index.htm,index.cgi"
function web.index_files( index_files)
  web.setOption("index_files",index_files)
end 

---"extension1=type1,exten- sion2=type2,...". 
---"mongoose -m .cpp=plain/text,.java=plain/text"
---Default: ""
function web.extra_mine_types( mine_types)
  web.setOption("extra_mine_types",mine_types)
end

-- Default: ""
function web.ssl_certificate( file ) 
 web.setOption("ssl_certificate",file)
end 

-- Default number of threads 10
function web.num_threads( worker_threads)
  web.num_threads("num_threads",tostring(worker_threads))
end






lp.setoutfunc ( "web.print_a")


function web.url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end



 function web.url_encode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
            function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str	
  end







--[[
--- These are lua test functions and lua webScripts

--- conventional lua function
function webTest()
  local queryString
  
  queryString = web.getEnv("QUERY_STRING")
  if queryString ~= nil then
    web.print("queryString  "..queryString)
  else
    web.print("nil queryString")
  end
  return 0
end

--- This function demonstrates the use of Lua Template function
--- <?  lua code to execute ?>  output is through web.dump
--- <?=  lua expressiong ??  output is through lua expression
function webTest1()
  local data
  data = lp.translate("This is a test <?= 'of the macro system ' ?>")
  lp.execute(data)
end

--]]
