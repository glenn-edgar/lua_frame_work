include ../Makefile.def 

LIBPATH = -L.  
LIBS =   -lm -ldl -lpthread   
INC = -I. -I../sqlite
PRGNAME = sqliteShell

 

all : CFLAGS = $(GLOBAL_CFLAGS) $(COMMONCFLAGS) $(X86CFLAGS) 
all :  shell.o  sqlite3.o $(SUBDIRS)
	$(CC) -O2 -Wall -rdynamic -D_REENTRANT $(CFLAGS) $(INC)   -o $(PRGNAME)  shell.o sqlite3.o $(LIBPATH) $(LIBS)
	cp $(PRGNAME) ../../.

clean:
	rm -f sqliteShell
	rm -f *.o *~

shell.o : shell.c
	$(CC) -c shell.c $(CFLAGS) $(INC)

sqlite3.o : sqlite3.c
	$(CC) -c sqlite3.c $(CFLAGS) $(INC)

