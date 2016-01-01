


all : 
	make -C core
	make -C user_libraries/daven_i2c
	cp core/luaCore daven_i2c


clean :
	make -C user_libraries/daven_i2c clean
	make -C core clean
	rm -f *.o daven_i2c
	
