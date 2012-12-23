LIBS := \
	liblib.asm \
	libchk.asm \
	libcol.asm \
	libdev.asm \
	libdiv.asm \
	libgfx.asm \
	libmem.asm \
	libmth.asm \
	libmul.asm \
	librle.asm \
	libstr.asm

PP ?= cpp

stdlib: $(LIBS)

%.asm: %.arc
	@echo "Preprocessing $< ($(PP))"
	@$(PP) -x assembler-with-cpp -nostdinc $< -o $@
