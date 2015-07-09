# @configure_input@

ACLOCAL_AMFLAGS = -I m4

# Require clang to be installed on the system
#AM_DISTCHECK_CONFIGURE_FLAGS = --with-clang=system


SUBDIRS =
if BUNDLED_PPCG
SUBDIRS += ppcg
endif
if BUNDLED_PENCIL_UTIL
SUBDIRS += pencil_util
endif
if BUNDLED_PRL
SUBDIRS += prl
endif

pkgdata_SCRIPTS = pencilcc.py

CLEANFILES = pencilcc.py pencilcc

TESTS = \
	tests/check-simple.sh \
	tests/check-simple-keep.sh \
	tests/check-simple-nativeexpr.sh

EXTRA_DIST = \
	autogen.sh \
	README \
	examples \
	get-scala.sh get-antlr3.sh get-polybench.sh \
	scala antlr3 polybench \
	tests/simple.c

AM_TESTS_ENVIRONMENT = \
	export PENCILCC="$(abs_builddir)/pencilcc"; \
	export TESTSRCDIR="`dirname "$(abs_srcdir)/$${b}"`"; \
	export TESTBUILDDIR="`dirname "$(abs_builddir)/$${b}"`/check/`basename $${b}`"; \
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
	${srcdir}/get-scala.sh

antlr3: get-antlr3.sh
	${srcdir}/get-antlr3.sh

polybench: get-polybench.sh
	${srcdir}/get-polybench.sh

# Get the packages so they can be used by "make check"
dist-local: scala antlr3 polybench

installcheck-local:
	for test in ${TESTS}; do \
		export PENCILCC="${bindir}/pencilcc"; \
		export TESTSRCDIR="`dirname "$(abs_srcdir)/$${test}"`"; \
		export TESTBUILDDIR="`dirname "$(abs_builddir)/$${test}"`/installcheck/`basename $${test}`"; \
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
