# @configure_input@

ACLOCAL_AMFLAGS = -I m4

# Require clang to be installed on the system
#AM_DISTCHECK_CONFIGURE_FLAGS = --with-clang=system


SUBDIRS =
if BUNDLED_PPCG
SUBDIRS += ppcg
endif
if BUNDLED_PENCIL_UTIL
SUBDIRS += pencil-headers
endif
if BUNDLED_PRL
SUBDIRS += prl
endif

pkgdata_SCRIPTS = pencilcc.py penciltool.py

CLEANFILES = pencilcc.py pencilcc penciltool.py penciltool

TESTS = \
	tests/polybench_test.sh \
	tests/check-simple.sh \
	tests/check-simple-keep.sh \
	tests/check-simple-keep-cuda.sh \
	tests/check-structbyval-prl.sh \
	tests/check-structbyval-cuda.sh \
	tests/check-prl_alloc.sh \
	tests/check-prl_mem_alloc.sh \
	tests/check-prl_manage.sh \
	tests/check-prl_manage_host.sh \
	tests/check-prl_manage_dev.sh \
	tests/check-pencil_npr_tag.sh \
	tests/check-simple-cuda.sh \
	tests/check-assume-prl.sh \
	tests/check-assume-cuda.sh \
	tests/check-multifile-prl.sh \
	tests/check-multifile-cuda.sh \
	tests/check-multilink-prl.sh \
	tests/check-multilink-cuda.sh \
	tests/check-cxx-prl.sh \
	tests/check-cxx-cuda.sh \
	tests/check-math-prl.sh \
	tests/check-math-cuda.sh \
	tests/check-summary.sh \
	tests/check-benchmark-prl.sh \
	tests/check-prl_mem_fill.sh

EXTRA_DIST = \
	autogen.sh \
	README \
	examples \
	get-polybench.sh \
	polybench \
	tests/simple.c \
	tests/check-simple.sh \
	tests/check-simple-keep.sh \
	tests/check-simple-keep-cuda.sh \
	tests/structbyval.c \
	tests/check-structbyval-prl.sh \
	tests/check-structbyval-cuda.sh \
	tests/prl_alloc.c \
	tests/check-prl_alloc.sh \
	tests/prl_mem_alloc.c \
	tests/check-prl_mem_alloc.sh \
	tests/prl_manage.c \
	tests/check-prl_manage.sh \
	tests/prl_manage_host.c \
	tests/check-prl_manage_host.sh \
	tests/prl_manage_dev.c \
	tests/check-prl_manage_dev.sh \
	tests/pencil_npr_tag.c \
	tests/check-pencil_npr_tag.sh \
	tests/check-simple-cuda.sh \
	tests/__pencil_assume.c \
	tests/check-assume-prl.sh \
	tests/check-assume-cuda.sh \
	tests/multilink_kernel1.pencil.c \
	tests/multilink_kernel2.pencil.c \
	tests/multilink_main.c \
	tests/check-multifile-prl.sh \
	tests/check-multifile-cuda.sh \
	tests/check-multilink-prl.sh \
	tests/check-multilink-cuda.sh \
	tests/check-cxx-prl.sh \
	tests/check-cxx-cuda.sh \
	tests/check-math-prl.sh \
	tests/check-math-cuda.sh \
	tests/check-summary.sh \
	tests/check-benchmark-prl.sh \
	tests/check-prl_mem_fill.sh

AM_TESTS_ENVIRONMENT = \
	export PENCILCC="$(abs_builddir)/pencilcc"; \
	export TESTSRCDIR="`dirname "$(abs_srcdir)/$${b}"`"; \
	export TESTBUILDDIR="`dirname "$(abs_builddir)/$${b}"`/check/`basename $${b}`"; \
	$(MKDIR_P) "$${TESTBUILDDIR}";

pencilcc: pencilcc.py
	ln -sf $< $@

penciltool: penciltool.py
	ln -sf $< $@

all-local: pencilcc penciltool

install-exec-local:
	$(LN_S) -f $(DESTDIR)$(pkgdatadir)/pencilcc.py $(DESTDIR)$(bindir)/pencilcc
	$(LN_S) -f $(DESTDIR)$(pkgdatadir)/penciltool.py $(DESTDIR)$(bindir)/penciltool

uninstall-local:
	rm -f $(DESTDIR)$(bindir)/pencilcc
	rm -f $(DESTDIR)$(bindir)/penciltool

# Dowload from the internet
polybench: get-polybench.sh
	${srcdir}/get-polybench.sh

# Get the packages so they can be used by "make check"
dist-local: polybench

installcheck-local:
	@for test in ${TESTS}; do \
		export PENCILCC="${bindir}/pencilcc"; \
		export TESTSRCDIR="`dirname "$(abs_srcdir)/$${test}"`"; \
		export TESTBUILDDIR="`dirname "$(abs_builddir)/$${test}"`/installcheck/`basename $${test}`"; \
		$(MKDIR_P) "$${TESTBUILDDIR}"; \
		echo "Checking `basename $${test}` ..."; \
		( cd "$${TESTBUILDDIR}" && if test -f "$(abs_builddir)/$${test}"; then "$(abs_builddir)/$${test}"; else "$(abs_srcdir)/$${test}"; fi) || exit 1; \
	done

clean-local:
	@for test in ${TESTS}; do \
		TESTBUILDDIR="`dirname "$(abs_builddir)/$${test}"`"; \
		rm -rf "$${TESTBUILDDIR}/check"; \
		rm -rf "$${TESTBUILDDIR}/installcheck"; \
	done
