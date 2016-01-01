#include ../Makefile.def 

LIBS =   -lm

PRGNAME = bin2c

 


all :   bin2c.o
	gcc  bin2c.o -o bin2c

bin2c.o : bin2c.c
	gcc -c $(CFLAGS) $(INC) bin2c.c


clean:
	rm -f bin2c
	rm  -f *.o
