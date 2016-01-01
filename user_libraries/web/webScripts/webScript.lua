--
local temp;
local handle;


function assemblePassWord()

  local passFile;
  local user
  local password
  local splitArray

  
  passFile = io.open("password.web","r")
  for line in passFile:lines() 
  do 
     splitArray = string.split( line, ",")
     user = splitArray[1]
     password = splitArray[2]
     level = tonumber(splitArray[3])

     if level > 0 then
       web.editPassword("passwords/adminPwd","indyme.com",user,password)
       web.editPassword("passwords/basePwd","indyme.com",user,password)
     else
       web.editPassword("passwords/basePwd","indyme.com",user,password)
     end
     
  end
  passFile:close();
  os.execute(" cp passwords/adminPwd web_pages/.htpasswd")

end




function index_function()
  web.print("lua web print function")
end






--------------------- START THE WEB SERVER ------------------------
web.clear_dynamic_uri_table()
web.set_dynamic_uri("/index.html", index_function )
web.set_dynamic_uri("/index.htm",  index_function )

os.execute("rm -f passwords/*")
web.init()
web.set_document_root("web_pages")
--web.access_log_file("web_access.log")
web.error_log_file( "web_error.log")
web.ssl_certificate("server.pem" ) 
web.set_listening_port("8070,8060s")
web.put_delete_passwords_file("web_pages/.htpasswd")

web.start()

---
---
---
assemblePassWord()



