---
---
---  File: couchdbScripts.lua
---
---  Implements the lua interface to lua
---
---

couchdb.localIp = "http://127.0.0.1:5984"

function couchdb.hello()
  local response, data, returnValue
  returnValue = false
  response,data   = couchdb.get(couchdb.localIp)
  if response == 200 then
    if data ~= nil then
       data = json.decode( data)
       if data.couchdb == "Welcome" then
           returnValue = true
       end
    end
  end
  return returnValue
end


function couchdb.config()
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/_config")
  data = json.decode(data)
  return response,data
end

function couchdb.status()
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/_stats")
  data = json.decode(data)
  return response,data
end

function couchdb.uuids(count)
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/_uuids?count="..count)
  data = json.decode(data)
  return response,data
end

function couchdb.createDb( dbName )
  local response, data, returnValue
  response,data   = couchdb.put(couchdb.localIp.."/"..dbName)
  data = json.decode(data)
  if data.ok == true then returnValue = true else returnValue = false end 
  return returnValue
end

function couchdb.deleteDb( dbName )
  local response, data, returnValue
  response,data   = couchdb.delete(couchdb.localIp.."/"..dbName)
  data = json.decode(data)
  if data.ok == true then returnValue = true else returnValue = false end 
  return returnValue
end

function couchdb.deleteAllDb()
  
  response,data = couchdb.listAllDb()
  if response == 200 then
    for i,j in ipair(data) do
      print(j)
      couchdb.deleteDb(j)
    end
  end
end


function couchdb.listAllDb( )
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/_all_dbs")
  data = json.decode(data)
  return response,data
end


function couchdb.dbInfo(dbName)
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/"..dbName)
  data = json.decode(data)
  return response,data
end


function couchdb.replicateDb(sourceDb,targetDb)
 local temp
 local data
 data = '{"source":"'..sourceDb..'" , "target":"'..targetDb..'"}'
 temp = "curl -X POST http://127.0.0.1:5984/_replicate -H 'Content-Type: application/json' -d '" .. data .."'"
 print(temp)
 os.execute(temp)

 
-- curl -X POST http://127.0.0.1:5984/_replicate -H Content-Type: application/json' -d '{"source":"guestbook", "target":"http://127.0.0.1:5984/guestbook-replica"}'
 
 return response,data
end


function couchdb.compactDb(dbName)
 local response,data
 response,data   = couchdb.post(couchdb.localIp.."/"..dbName.."/_compact")
 return response,data
end


function couchdb.createDoc(dbName, doc)
 local response,data, jdoc
 jdoc = json.encode(doc)
 if doc.id ~= nil then
   response,data   = couchdb.put(couchdb.localIp.."/"..dbName.."/"..doc.id,jdoc)
 end
 if data ~= nil then
   data = json.decode(data)
   doc.rev = data.rev
 end
 return response,data
end

function couchdb.updateDoc(dbName,doc)
 local response,data, jdoc
 doc._rev = doc.rev
 jdoc = json.encode(doc)
 if doc.id ~= nil then
   response,data   = couchdb.put(couchdb.localIp.."/"..dbName.."/"..doc.id,jdoc)
 end
 if data ~= nil then
   data = json.decode(data)
   if data.rev ~= nil then
      doc.rev = data.rev
   end
 end
 return response,data
end

function couchdb.deleteDoc(dbName,doc)
 local response,data
 
 if doc.id ~= nil then
   response,data   = couchdb.delete(couchdb.localIp.."/"..dbName.."/"..doc.id.."?rev="..doc.rev)
 end
 return response,data
end


function couchdb.copyDoc(dbName,doc1,doc2)
local response,data,header
header = "Destination: "..doc2
response,data = couchdb.copy(couchdb.localIp.."/"..dbName.."/"..doc1, header);

 return response,data
-- curl -X COPY http://127.0.0.1:5984/contacts/andyjarrett -H "Destination: tylerdurden"
end


function couchdb.listAllDoc(dbName)
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/"..dbName.."/_all_docs?include_docs=true")
  data = json.decode(data)
  return response,data
end


function couchdb.viewDocument(dataBase,document)
  local response, data
  response,data   = couchdb.get(couchdb.localIp.."/"..dataBase.."/"..document)
  data = json.decode(data)
  return response,data
end




function couchdb.help()
 print("Couchdb core api functions")
 print(".hello()    ")
 print(".config()    ")
 print(".status()    ")
 print(".uuids()    ")
 print(".createDb( dbName )    ")
 print(".deleteDb( dbName )    ")
 print(".deleteAllDb()         ")
 print(".listAllDb( dbName )    ")
 print(".dbInfo()    ")
 print(".replicateDb( )    ")
 print(".compactDb()    ")
 print(".createDoc()    ")
 print(".updateDoc()    ")
 print(".deleteDoc()    ")
 print(".copyDoc()    ")
 print(".listAllDocs()    ")
 print(".listDocKey()    ")
 print(".listDocKey()    ")
 print(".listModifiedDoc()    ")
 print(".listModifiedDocKey()    ")
 print(".viewDocment()     ")
 print(".createAttachment()     ")
 print(".deleteAttachment()    ")
 print(".updateAttachment()    ")
 print(".getAttachment()    ")
 print(".bulkDocumentUpload    ")
 print(".bulkDocumentDelete()     ")
 print(".createDesignDoc()       ")
 print(".queryTemporaryView()    ")
 print(".queryPermanentView()    ") 
 print(".queryPermanentViewKeySet()      ")
 print(".show()      ")
 print(".list()          ")
 print(".listWithKey()       ")

end

--
--
-- These are TBD Functions
--
--
--
--

function couchdb.listDocKey()
end

function couchdb.listDocKey()
end

function couchdb.listModifiedDoc()
end


function couchdb.listModifiedDocKey()
end


function couchdb.createAttachment()
end

function couchdb.deleteAttachment()
end

function couchdb.updateAttachment()
end

function couchdb.getAttachment()
end

function couchdb.bulkDocumentUpload()
end

function couchdb.bulkDocumentDelete()
end

function couchdb.createDesignDoc()
end

function couchdb.queryTemporaryView()
end

function couchdb.queryPermanentView()
end

function couchdb.queryPermanentViewKeySet()
end

function couchdb.show()
end

function couchdb.list()
end

function couchdb.listWithKey()

end
