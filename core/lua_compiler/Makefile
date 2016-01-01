include ../Makefile.def 

LIBPATH = -L.  -L../lua/src
LIBS =   -llua -lm -ldl -lpthread 
INC = -I. -I../lua/src
PRGNAME = luac

 

all : CFLAGS = $(GLOBAL_CFLAGS) $(COMMONCFLAGS) $(X86CFLAGS) 
all :  stub.o luac.o print.o $(SUBDIRS)
	$(CC) -O2 -Wall -rdynamic -D_REENTRANT $(CFLAGS) $(INC)   -o $(PRGNAME)  luac.o stub.o print.o $(LIBPATH) $(LIBS)

clean:
	rm -f luac
	rm -f *.o *~

luac.o : luac.c
	$(CC) -c luac.c $(CFLAGS) $(INC)


stub.o : stub.c
	$(CC) -c stub.c $(CFLAGS) $(INC)

print.o: print.c
	$(CC) -c print.c $(CFLAGS) $(INC)


