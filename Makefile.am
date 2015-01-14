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

CLEANFILES = pencilcc.py pencilcc

pencilcc: pencilcc.py
	ln -sf $< $@

all-local: pencilcc

pkgdata_SCRIPTS = pencilcc.py

install-exec-local:
	$(LN_S) -f $(DESTDIR)$(pkgdatadir)/pencilcc.py $(DESTDIR)$(bindir)/pencilcc

uninstall-local:
	rm -f $(DESTDIR)$(bindir)/pencilcc
