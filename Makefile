CFLAGS=-std=c99
# dont add -lpthread for win32
LDFLAGS=-lpthread

all: cputest

cputest: cputest.c
	cc $(CFLAGS) cputest.c $(LDFLAGS) -o cputest
