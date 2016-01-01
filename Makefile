


all : 
	make -C core
	make -C user_libraries/
	cp core/luaCore web


clean :
	make -C user_libraries/ clean
	make -C core clean
	rm -f web *~
	
