# Makefile for preprocessing the ARC standard library.

LIBS := \
	liblib.asm \
	libchk.asm \
	libcol.asm \
	libdev.asm \
	libdiv.asm \
	libgfx.asm \
	libmem.asm \
	libfnt.asm \
	libcon.asm \
	libmth.asm \
	libmul.asm \
	librle.asm \
	libstr.asm

all: stdlib README.mkd

stdlib: $(LIBS)

README.mkd: $(LIBS)
	@echo "- Creating $@..."
	@cat lib*.arc | grep "^\!" | sed "s/^\! //" > README.mkd

%.asm: %.arc
	@echo "- Processing $<..."
	@../support/arcpp $< $@

clean:
	@rm -v $(LIBS)
