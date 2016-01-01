--- 
---
---   s_expression_manager.lua
---
---
---
---

---  s_object types
---
--- primitiveType
---  .type = "primitive"
---  .function 
---  .parameters
---   .initFlag
---   .activeFlag
---
---




s_mgr = {}


s_mgr.chain_queue = {}



function s_mgr.import_compile_chain( chainId, json_string )

end


function s_mgr.export_chain( chainId )

end

function s_mgr.execute_chain( j, eventObject )
  local temp
  temp = {}
  
   -- evaluate parameters
  j.evaluateParameters = temp
  
  j.function( j, eventObject)
end



---
---  eventObject has the following fields
---  .queueName = queueName
---  .event              = event
---   .data                =  data
----
function s_mgr.execute_event(  eventObject )

  for i,j in ipairs( s_mgr.chain_queue ) do
     s_mgr.execute_chain( j, eventObject )
  end
end


























function s_mgr.description()
  return "s_expression chain flow manager"
end

function s_mgr.help()

end