# Makefile for building arcvm, the ARC virtual machine

CC := gcc
CFLAGS := -Wall -Wextra -Wno-unused-variable -ftrapv -pedantic -std=c99 -Os -pipe $(shell sdl-config --cflags)

all: arcvm tags

OBJECTS := arcvm.o \
	bit.o \
	mem.o \
	vm.o \
	config.o

arcvm: $(OBJECTS)
	@echo "- Linking $@..."
	@$(CC) $(shell sdl-config --cflags) $^ -o $@ $(shell sdl-config --libs)

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
