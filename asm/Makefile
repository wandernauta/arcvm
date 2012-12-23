# Makefile for preprocessing the ARC standard library and examples.

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

SAMPLES := \
	logo.asm \
	hello.asm

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
