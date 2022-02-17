CIPHEROBJS = main.o

all: prog

%.o : %.s
	as -g -o $@ $<

prog: $(CIPHEROBJS)
	ld -g -o prog $(CIPHEROBJS)

