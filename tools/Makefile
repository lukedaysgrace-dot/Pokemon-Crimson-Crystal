.PHONY: all clean

CC := gcc
CFLAGS := -O3 -std=c99 -Wall -Wextra -Wno-missing-field-initializers

ifeq ($(OS),Windows_NT)
EXEEXT := .exe
endif

tools := \
	lzcomp$(EXEEXT) \
	png_dimensions$(EXEEXT) \
	scan_includes$(EXEEXT) \
	palette$(EXEEXT) \
	pokemon_animation$(EXEEXT) \
	pokemon_animation_graphics$(EXEEXT) \
	gfx$(EXEEXT) \
	md5$(EXEEXT)
all: $(tools)
	@:

clean:
	rm -f $(tools)

gfx$(EXEEXT) md5$(EXEEXT): common.h

%$(EXEEXT): %.c
	$(CC) $(CFLAGS) -o $@ $<
