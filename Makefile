# Makefile for building arcvm, the ARC virtual machine

CC := gcc
LDFLAGS := $(shell pkg-config --libs sdl) -lsigsegv
CFLAGS := -Wall -Wextra -pedantic -std=c99 -g -O0 $(shell pkg-config --cflags sdl)

all: arcvm tags

arcvm: arcvm.o
	@echo "- Linking $@..."
	@$(CC) $(LDFLAGS) $^ -o $@

%.o: %.c
	@echo "- Compiling $^ ($(CC))..."
	@$(CC) $(CFLAGS) -c $^ -o $@

tags: $(wildcard *.c) $(wildcard *.h)
	@echo "- Updating tags..."
	@ctags *.c

clean:
	@rm -fv *.o arcvm tags

.PHONY: clean
