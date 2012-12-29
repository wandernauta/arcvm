# Makefile for preprocessing the ARC standard library and examples.

LIBS := \
	libchk.asm \
	libchr.asm \
	libcol.asm \
	libcon.asm \
	libdev.asm \
	libfnt.asm \
	libgfx.asm \
	liblib.asm \
	libmem.asm \

SAMPLES := \
	logo.asm \
	hello.asm \
	wargames.asm \
	typewriter.asm \
	edit.asm

all: stdlib samples README.mkd

stdlib: $(LIBS)
samples: $(SAMPLES)

README.mkd: $(LIBS)
	@echo "- Creating $@..."
	@cat lib*.arc | grep "^\!" | sed "s/^\! //" > README.mkd

%.asm: %.arc
	@echo "- Processing $<..."
	@../support/arcpp $< $@

clean:
	@rm -v $(LIBS)
