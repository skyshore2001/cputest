CFLAGS=-std=c99
LDFLAGS=-lpthread

all: cputest

cputest: cputest.c
	cc $(CFLAGS) cputest.c $(LDFLAGS) -o cputest
