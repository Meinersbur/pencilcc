#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([pencil-driver], [0.0], [carp-pencil@imperial.ac.uk])
AC_CONFIG_MACRO_DIR([m4])

# Automake
AC_CONFIG_AUX_DIR([build-aux]) 
AM_INIT_AUTOMAKE([-Wall -Werror foreign])

#AC_CONFIG_SRCDIR([pencil-util/runtime/pencil_runtime.h])
#AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC
AC_PROG_CPP
AC_PROG_LN_S
AM_PROG_AR
AC_PROG_LIBTOOL
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




AC_SUBST(abs_builddir)
AC_SUBST(abs_srcdir)


AC_SUBST(PPCG_BUILDDIR)
AC_SUBST(PPCG_SRCDIR)
AC_SUBST(with_ppcg)
AX_SUBMODULE(ppcg,build|bundled|system,bundled)
case "$with_ppcg" in
no)
	;;
bundled)
	;;
build)
	PPCG_BUILDDIR=`echo @abs_builddir@ | $with_ppcg_builddir/config.status --file=-`
	PPCG_SRCDIR=`echo @abs_srcdir@ | $with_ppcg_builddir/config.status --file=-`
	;;
system)
	PKG_CHECK_MODULES([PPCG], [ppcg])
	;;
esac




#AX_SUBMODULE(pencil,build|bundled|system|no,bundled)
case "$with_pencil" in
no)
	;;
bundled)
	;;
build)
	;;
system)
	PKG_CHECK_MODULES([PPCG], [ppcg])
	;;
esac


#AX_SUBMODULE_FWD(isl,build|bundled|system,bundled)

#AX_SUBMODULE_FWD(pet,build|bundled|system,bundled)

#AX_SUBMODULE_FWD(clang,build|system,system)


AC_CONFIG_FILES([pencilcc.py], [chmod +x pencilcc.py])
AC_CONFIG_FILES([Makefile])
#AC_CONFIG_FILES([pencil-util/runtime/Makefile])

if test x"$with_ppcg" = xbundled; then
	AC_CONFIG_SUBDIRS(ppcg)
fi

#if test x"$with_pencil" = xbundled; then
#	AC_CONFIG_SUBDIRS(pencil)
#fi

#AC_CONFIG_COMMANDS_POST([
#	dnl pass on arguments to subdir configures, but don't
#	dnl add them to config.status
#	ac_configure_args="$ac_configure_args $ppcg_configure_args"
#])

AC_OUTPUT
