# Copyright 2008 Onyx Engineering 
# This file is licensed as MIT
 
include ../../Makefile.def


INC = -I. -I../../core/lua/src 
USER_MEMORY_INCLUDE = Y
LIBNAME = libRS485.so
CFLAGS = -Wall  
CFLAGS += -DUSER_MEMORY_INCLUDE=1


SOURCES := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SOURCES))
HEADERS := $(wildcard ../include/*.h)


all : prebuild

	$(CC) -shared $(CFLAGS) $(INC) -Wl,-soname=$(LIBNAME) -o $(LIBNAME) $(OBJS) $(LIBPATH) $(LIBS)
	cp *.so ../

prebuild: 
ifeq ($(USER_MEMORY_INCLUDE),Y)

#generating scripts as compressed include files
	rm  -f init.h
	../../core/bin2c/bin2c init.dat > init.h
	rm -f *.o
	$(CC) -fPIC -D_REENTRANT -c $(CFLAGS) $(INC) $(SOURCES)
else
	$(CC) -fPIC -D_REENTRANT -c $(CFLAGS) $(INC) $(SOURCES)
endif

clean :
	rm -f *.o *.a *.so *~

