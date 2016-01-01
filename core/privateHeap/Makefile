
# copyright 2008 Onyx Engineering
# this file is licensed as MIT

include ../Makefile.def 
ARCHIVER = ar
RANLIB = ranlib

LIBNAME = libprivateHeap.a

INC = -I. -I../lua/src

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
	rm -f *.o *.a *.so *~
	


