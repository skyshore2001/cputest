CFLAGS=
LDFLAGS=-lpthread

all: cputest

cputest: cputest.c
	cc cputest.c $(LDFLAGS) -o cputest
