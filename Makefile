LDLIBS=-lm

all: c_progs
c_progs: petools.o 184

184: 184.o petools.o

