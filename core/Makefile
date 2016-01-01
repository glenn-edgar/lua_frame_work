
# Copyright 2008 Onyx Engineering 
# This file is licensed as MIT
 
include Makefile.def

LIBPATH = -L. -Llibs  -LprivateHeap -LluaSystem  -LterminalHandler -LluaExpat -LprivateHeap -LluaSystem -Llua   \
-L sqlite/sqlite  -L  luaSqlite -L lua/src -Lexpat-2.0.0/.libs  -Lexpat-2.0.0/.libs \
-L luaPatString -L luaShell -LRS232 

LIBS =   -lprivateHeap -llua -lluaShell  -lluaSystem -lluars232 \
      -lm -ldl    -lpthread  
INC = -I. -IprivateHeap  -IluaSystem   -Ilua/src
PRGNAME = luaCore


USER_MEMORY_INCLUDE = Y
all : CFLAGS = $(GLOBAL_CFLAGS) $(COMMONCFLAGS) $(X86CFLAGS) 
all : CFLAGS += -DAPP_NAME='"monitorBox"'
#all : CFLAGS += -DLUA_PRIVATE_HEAP
all : CFLAGS += -DLUA_CONSOLE_HEAP=10000000
all : CFLAGS += -DLUA_BACKGROUND_HEAP=10000000
all : CFLAGS += -DUSER_MEMORY_INCLUDE=1
all : CFLAGS += -DLOAD_EXPAT
all : CFLAGS += -DLOAD_SQL
#all : CFLAGS += -DLOAD_HTTP
all : CFLAGS += -DPAT_STRING
all : CFLAGS += -DLUA_NETWORK
all : CFLAGS += -DWEB_UPLOAD="\"user_scripts/\""

all : prebuild $(SUBDIRS)
	make -C lua/src
	make -C privateHeap
	make -C luaSystem
	make -C luaShell
	make -C RS232
	make -C lua_compiler
	cp    lua_compiler/luac .
	$(CC) -O2 -Wall  -rdynamic -D_REENTRANT $(CFLAGS) $(INC)   -o $(PRGNAME)  main.o constructState.o $(LIBPATH) $(LIBS)


#	$(CC) -rdynamic $(CFLAGS) $(INC)   -o $(PRGNAME)  $(OBJS) $(LIBPATH) $(LIBS) 


prebuild: 
	make -C bin2c
ifeq ($(USER_MEMORY_INCLUDE),Y)
#generating scripts as compressed include files
	./rom.sh
	rm -f main.o
	rm -f constructState.o
endif
	$(CC) -c $(CFLAGS) $(INC) main.c constructState.c


clean :
	make -C bin2c clean
	make -C lua/src clean
	make -C privateHeap clean
	make -C luaSystem clean
	make -C RS232
	make -C privateHeap clean
	make -C lua_compiler clean
	make -C luaShell clean
	rm -f $(OBJS) $(PRGNAME) *.a *~ *.o
	
