


all : 
	make -C core
	make -C user_libraries/io_pod
	cp core/luaCore io_pod


clean :
	make -C user_libraries/io_pod clean
	make -C core clean
	rm -f io_pod
	
