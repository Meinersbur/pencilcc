# @configure_input@

ACLOCAL_AMFLAGS = -I m4

if BUNDLED_PPCG
    MAYBE_PPCG = ppcg
endif
if BUNDLED_PENCIL
    MAYBE_PENCIL = pencil
endif
if BUNDLED_PENCIL_UTIL
    MAYBE_PENCIL_UTIL = pencil-util
endif

SUBDIRS = $(MAYBE_PPCG) $(MAYBE_PENCIL) $(MAYBE_PENCIL_UTIL)

pencilcc: pencilcc.py
	ln -sf $< $@

all-local: pencilcc

clean-local:
	rm -f pencilcc
