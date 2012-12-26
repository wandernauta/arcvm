# Makefile for building arcvm, the ARC virtual machine

CC := gcc
LDFLAGS := $(shell sdl-config --libs) -lsigsegv -lprofiler
CFLAGS := -Wall -Wextra -Wno-unused-variable -fwrapv -pedantic -std=c99 -g -O4 -pipe $(shell sdl-config --cflags)

all: arcvm tags

OBJECTS := arcvm.o \
	bit.o \
	mem.o \
	vm.o \
	config.o

arcvm: $(OBJECTS)
	@echo "- Linking $@..."
	@$(CC) $(LDFLAGS) $^ -o $@

%.o: %.c
	@echo "- Compiling $< ($(CC))..."
	@$(CC) $(CFLAGS) -c $< -o $@

tags: $(wildcard *.c) $(wildcard *.h)
	@echo "- Updating tags..."
	@ctags *.c

deps: $(wildcard *.c) $(wildcard *.h)
	@echo "- Recalculating dependencies..."
	@$(CC) $(CFLAGS) -MM *.c > deps

clean:
	@rm -rvf *.o

include deps

.PHONY: clean
