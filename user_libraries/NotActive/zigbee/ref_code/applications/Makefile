# Copyright 2008 Onyx Engineering
# This file is licensed MIT
include ../Makefile.def
ARCHIVER = ar
RANLIB = ranlib

LIBNAME = libapplications.a

INC =  -I../lua/src -I../privateHeap -I../luaSystem 

SOURCES := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SOURCES))
HEADERS := $(wildcard ../include/*.h)


all : AR = $(ARCHIVER)
all : RL = $(RANLIB)
all : $(OBJS)
	$(AR) cru $(LIBNAME) $(OBJS)
	$(RL) $(LIBNAME)

$(OBJS) : $(HEADERS) $(SOURCES)
	$(CC) -c -O2 -Wall $(CFLAGS) $(INC) $(SOURCES)




clean :
	rm -f *.o *.a *.so
	


