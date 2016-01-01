all : 
	make -C avro-c	
	make -C luaJson
	make -C luaCJson	
	make -C web
	make -C luaPatString
	make -C sqlite
	make -C luaNetwork
	make -C expat
	make -C RS485
	make -C web
	make -C cf_controller
	make -C basicCompression
	make -C couchdb
	make -C cf_compiler
	make -C cf_chain_flow
	make -C chain_flow_embedded_compiler
	make -C template


clean :
	make -C avro-c clean
	make -C luaJson clean
	make -C luaCJson clean
	make -C web  clean
	make -C luaPatString clean
	make -C sqlite clean
	make -C luaNetwork clean	
	make -C expat clean
	make -C RS485 clean
	make -C web clean
	make -C cf_controller clean
	make -C basicCompression clean
	make -C couchdb clean
	make -C cf_compiler clean
	make -C cf_chain_flow clean
	make -C chain_flow_embedded_compiler clean
	make -C template clean
	rm -f *.so *~
