#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([pencilcc], [0.4], [pencilcc@meinersbur.de])
AC_CONFIG_MACRO_DIR([m4])

# Automake
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([1.11 -Wall foreign tar-ustar])

# Checks for programs.
AC_PROG_CPP
AC_PROG_LN_S
PKG_PROG_PKG_CONFIG

AX_DETECT_GIT_HEAD
AC_SUBST(GIT_HEAD_ID)


dnl Is there no official way yo get the build directory?
abs_builddir=`pwd` # ${ac_abs_builddir} 
abs_srcdir=$(readlink -m "${srcdir}")
AC_SUBST(abs_builddir)
AC_SUBST(abs_srcdir)

subconfigure_addargs=""


AX_SUBMODULE_FWD(isl,build|bundled|system,bundled)
AX_SUBMODULE_FWD(pet,build|bundled|system,bundled)
AX_SUBMODULE_FWD(clang,build|system,system)


AC_SUBST(PPCG_BUILDDIR)
AC_SUBST(PPCG_SRCDIR)
AC_SUBST(with_ppcg)
AX_SUBMODULE(ppcg,no|build|bundled|system,bundled)
case "$with_ppcg" in
no)
	;;
bundled)
	PPCG_BUILDDIR="${abs_builddir}/ppcg"
	PPCG_SRCDIR="${abs_srcdir}/ppcg"
	;;
build)
	PPCG_BUILDDIR=`echo @abs_builddir@ | $with_ppcg_builddir/config.status --file=-`
	PPCG_SRCDIR=`echo @abs_srcdir@ | $with_ppcg_builddir/config.status --file=-`
	;;
system)
	PKG_CHECK_MODULES([PPCG], [ppcg])
	;;
esac
AM_CONDITIONAL(BUNDLED_PPCG, test "x$with_ppcg" = xbundled)


AC_SUBST(PENCIL_UTIL_BUILDDIR)
AC_SUBST(PENCIL_UTIL_SRCDIR)
AC_SUBST(with_pencil_util)
AX_SUBMODULE(pencil-util,no|build|bundled|system|no,bundled)
case "$with_pencil_util" in
no)
	;;
bundled)
	PENCIL_UTIL_BUILDDIR="${abs_builddir}/pencil-util"
	PENCIL_UTIL_SRCDIR="${abs_srcdir}/pencil-util"
	subconfigure_addargs="${subconfigure_addargs} --with-pencil-util=build --with-pencil-util-builddir=${PENCIL_UTIL_BUILDDIR}" # Will overwrite inherited --with-pencil=bundled argument 
	;;
build)
	PENCIL_UTIL_BUILDDIR=`echo @abs_builddir@ | $with_pencil_util_builddir/config.status --file=-`
	PENCIL_UTIL_SRCDIR=`echo @abs_srcdir@ | $with_pencil_util_builddir/config.status --file=-`
	;;
system)
	;;
esac
AM_CONDITIONAL(BUNDLED_PENCIL_UTIL, test x"$with_pencil_util" = xbundled)


AC_SUBST(PRL_BUILDDIR)
AC_SUBST(PRL_SRCDIR)
AC_SUBST(with_prl)
AX_SUBMODULE(prl,no|build|bundled|system|no,bundled)
case "$with_pencil_util" in
no)
	;;
bundled)
	PRL_BUILDDIR="${abs_builddir}/prl"
	PRL_SRCDIR="${abs_srcdir}/prl"
	subconfigure_addargs="${subconfigure_addargs} --with-prl=build --with-prl-builddir=${PRL_BUILDDIR}" # Will overwrite inherited --with-pencil=bundled argument
	;;
build)
	PRL_BUILDDIR=`echo @abs_builddir@ | $with_prl_builddir/config.status --file=-`
	PRL_SRCDIR=`echo @abs_srcdir@ | $with_prl_builddir/config.status --file=-`
	;;
system)
	;;
esac
AM_CONDITIONAL(BUNDLED_PRL, test x"$with_prl" = xbundled)



AC_MSG_CHECKING([for PolyBench])
AC_SUBST(POLYBENCH_DIR)
AC_ARG_WITH(polybench,
	[AS_HELP_STRING([--with-polybench=DIR],[PolyBench's location @<:@using bundled by default@:>@])],
	[
		with_polybench_result="${with_polybench}"
	],[
		dnl Default option: if ./polybench subdirectory exists
		if test -z ""; then
			if test -d "${abs_srcdir}/polybench"; then
				with_polybench="${abs_srcdir}/polybench"
				subconfigure_addargs="${subconfigure_addargs} --with-polybench=${abs_srcdir}/polybench"
				with_polybench_result="${with_polybench} (bundled)"
			else
				with_polybench=no
				subconfigure_addargs="${subconfigure_addargs} --without-polybench"
				with_polybench_result="no (bundled not found)"
			fi
		fi
	]
	)
AC_SUBST(POLYBENCH_DIR)
POLYBENCH_DIR=$with_polybench
AC_MSG_RESULT(${with_polybench_result})



AC_CONFIG_FILES([pencilcc.py], [chmod +x pencilcc.py])
AC_CONFIG_FILES([penciltool.py], [chmod +x penciltool.py])
AC_CONFIG_FILES([tests/polybench_test.sh], [chmod +x tests/polybench_test.sh])
AC_CONFIG_FILES([Makefile])


if test x"$with_ppcg" = xbundled; then
	AC_CONFIG_SUBDIRS(ppcg)
fi
if test x"$with_pencil_util" = xbundled; then
	AC_CONFIG_SUBDIRS(pencil-headers)
fi
if test x"$with_prl" = xbundled; then
	AC_CONFIG_SUBDIRS(prl)
fi

AC_CONFIG_COMMANDS_POST([
	dnl pass on arguments to subdir configures, but don't
	dnl add them to config.status
	ac_configure_args="${ac_configure_args} ${subconfigure_addargs}"
])
AC_OUTPUT
