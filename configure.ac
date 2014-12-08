#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([pencil-driver], [0.0], [carp-pencil@imperial.ac.uk])
AC_CONFIG_MACRO_DIR([m4])

# Automake
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AM_MAINTAINER_MODE([enable])

#AC_CONFIG_SRCDIR([pencil-util/runtime/pencil_runtime.h])
#AC_CONFIG_HEADERS([config.h])

# Checks for programs.
#AC_PROG_CC
AC_PROG_CPP
#AC_PROG_LN_S
#AM_PROG_AR
#AC_PROG_LIBTOOL
PKG_PROG_PKG_CONFIG

# Checks for header files.
#AC_CHECK_HEADERS([stddef.h stdlib.h])

# Checks for typedefs, structures, and compiler characteristics.
#AC_CHECK_HEADER_STDBOOL
#AC_C_INLINE
#AC_TYPE_SIZE_T

# Checks for library functions.
#AC_FUNC_MALLOC
#AC_CHECK_FUNCS([floor pow sqrt])


AX_DETECT_GIT_HEAD
AC_SUBST(GIT_HEAD_ID)
#echo '#define GIT_HEAD_ID "'$GIT_HEAD_ID'"' > gitversion.h



abs_builddir=`pwd` # ${ac_abs_builddir}

AC_SUBST(abs_builddir)
AC_SUBST(abs_srcdir)




AC_SUBST(PPCG_BUILDDIR)
AC_SUBST(PPCG_SRCDIR)
AC_SUBST(with_ppcg)
AX_SUBMODULE(ppcg,build|bundled|system,bundled)
AX_SUBMODULE_FWD(isl,build|bundled|system,bundled)
AX_SUBMODULE_FWD(pet,build|bundled|system,bundled)
AX_SUBMODULE_FWD(clang,build|system,system)
case "$with_ppcg" in
no)
	;;
bundled)
	PPCG_BUILDDIR="${abs_builddir}/ppcg"
	PPCG_SRCDIR="${srcdir}/ppcg"
	oclutilities_path="${PPCG_SRCDIR}/ocl_utilities.c"
	;;
build)
	PPCG_BUILDDIR=`echo @abs_builddir@ | $with_ppcg_builddir/config.status --file=-`
	PPCG_SRCDIR=`echo @abs_srcdir@ | $with_ppcg_builddir/config.status --file=-`
	oclutilities_path="${PPCG_SRCDIR}/ocl_utilities.c"
	;;
system)
	PKG_CHECK_MODULES([PPCG], [ppcg])
	;;
esac
AM_CONDITIONAL(BUNDLED_PPCG, test "x$with_ppcg" = xbundled)



AC_SUBST(PENCIL_BUILDDIR)
AC_SUBST(PENCIL_SRCDIR)
AC_SUBST(with_pencil)
AX_SUBMODULE(pencil,build|bundled|system|no,bundled)
case "$with_pencil" in
no)
	;;
bundled)
	PENCIL_BUILDDIR="${abs_builddir}/pencil"
	PENCIL_SRCDIR="${srcdir}/pencil"
	;;
build)
	PENCIL_BUILDDIR=`echo @abs_builddir@ | $with_pencil_builddir/config.status --file=-`
	PENCIL_SRCDIR=`echo @abs_srcdir@ | $with_pencil_builddir/config.status --file=-`
	;;
system)
	;;
esac
AM_CONDITIONAL(BUNDLED_PENCIL, test "x$with_pencil" = xbundled)


AC_SUBST(PENCIL_UTIL_BUILDDIR)
AC_SUBST(PENCIL_UTIL_SRCDIR)
AC_SUBST(with_pencil_util)
AX_SUBMODULE(pencil-util,build|bundled|system|no,bundled)
case "$with_pencil_util" in
no)
	;;
bundled)
	PENCIL_UTIL_BUILDDIR="${abs_builddir}/pencil-util"
	PENCIL_UTIL_SRCDIR="${srcdir}/pencil-util"
	;;
build)
	PENCIL_UTIL_BUILDDIR=`echo @abs_builddir@ | $with_pencil_util_builddir/config.status --file=-`
	PENCIL_UTIL_SRCDIR=`echo @abs_srcdir@ | $with_pencil_util_builddir/config.status --file=-`
	;;
system)
	;;
esac
AM_CONDITIONAL(BUNDLED_PENCIL_UTIL, test x"$with_pencil_util" = xbundled)



AC_CONFIG_FILES([pencilcc.py], [chmod +x pencilcc.py])
AC_CONFIG_FILES([Makefile])



if test x"$with_ppcg" = xbundled; then
	AC_CONFIG_SUBDIRS(ppcg)
fi

if test x"$with_pencil" = xbundled; then
	AC_CONFIG_SUBDIRS(pencil)
fi

if test x"$with_pencil_util" = xbundled; then
	AC_CONFIG_SUBDIRS(pencil-util)
fi

AC_CONFIG_COMMANDS_POST([
	dnl pass on arguments to subdir configures, but don't
	dnl add them to config.status
	ac_configure_args="${ac_configure_args} --with-ocl_utilities=${oclutilities_path}"
])
AC_OUTPUT
