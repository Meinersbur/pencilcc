# @configure_input@

ACLOCAL_AMFLAGS = -I m4

# Require clang to be installed on the system
#AM_DISTCHECK_CONFIGURE_FLAGS = --with-clang=system


if BUNDLED_PENCIL_UTIL
MAYBE_PENCIL_UTIL = pencil-util
endif
if BUNDLED_PPCG
MAYBE_PPCG = ppcg
endif
if BUNDLED_PENCIL
MAYBE_PENCIL = pencil
endif

SUBDIRS = $(MAYBE_PENCIL_UTIL) $(MAYBE_PPCG) $(MAYBE_PENCIL) 

pkgdata_SCRIPTS = pencilcc.py

CLEANFILES = pencilcc.py pencilcc

EXTRA_DIST = \
	autogen.sh \
	README.md \
	examples \
	get-scala.sh get-antlr3.sh \
	scala antlr3 \
	tests/simple/check.sh \
	tests/simple/example.c

TESTS = tests/simple/check.sh

AM_TESTS_ENVIRONMENT = \
	export PENCILCC="$(abs_builddir)/pencilcc"; \
	export TESTSRCDIR="`dirname "$(abs_srcdir)/$${b}"`"; \
	export TESTBUILDDIR="`dirname "$(abs_builddir)/$${b}"`/check"; \
	$(MKDIR_P) "$${TESTBUILDDIR}";

pencilcc: pencilcc.py
	ln -sf $< $@

all-local: pencilcc

install-exec-local:
	$(LN_S) -f $(DESTDIR)$(pkgdatadir)/pencilcc.py $(DESTDIR)$(bindir)/pencilcc

uninstall-local:
	rm -f $(DESTDIR)$(bindir)/pencilcc


# Dowload from the internet
scala: get-scala.sh
	./get-scala.sh

antlr3: get-antlr3.sh
	./get-antlr3.sh

# Get the packages so they can be used by "make check"
dist-local: scala antlr3

installcheck-local:
	for test in ${TESTS}; do \
		export PENCILCC="${bindir}/pencilcc"; \
		export TESTSRCDIR="`dirname "$(abs_srcdir)/$${test}"`"; \
		export TESTBUILDDIR="`dirname "$(abs_builddir)/$${test}"`/installcheck"; \
		$(MKDIR_P) "$${TESTBUILDDIR}"; \
		echo "Checking `basename $${test}`..."; \
		( cd "$${TESTBUILDDIR}" && "$(abs_srcdir)/$${test}") || exit 1; \
	done

clean-local:
	for test in ${TESTS}; do \
		TESTBUILDDIR="`dirname "$(abs_builddir)/$${test}"`"; \
		rm -rf "$${TESTBUILDDIR}/check"; \
		rm -rf "$${TESTBUILDDIR}/installcheck"; \
	done
