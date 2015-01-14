#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([pencil-driver], [0.0], [carp-pencil@imperial.ac.uk])
AC_CONFIG_MACRO_DIR([m4])

# Automake
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AM_MAINTAINER_MODE([enable])

# Checks for programs.
AC_PROG_CPP
AC_PROG_LN_S
PKG_PROG_PKG_CONFIG

AX_DETECT_GIT_HEAD
AC_SUBST(GIT_HEAD_ID)
#echo '#define GIT_HEAD_ID "'$GIT_HEAD_ID'"' > gitversion.h


dnl I there no official way yo get the build directory?
abs_builddir=`pwd` # ${ac_abs_builddir} 
abs_srcdir="${srcdir}"

AC_SUBST(abs_builddir)
AC_SUBST(abs_srcdir)

subconfigure_addargs=""



AC_SUBST(PPCG_BUILDDIR)
AC_SUBST(PPCG_SRCDIR)
AC_SUBST(with_ppcg)
AX_SUBMODULE(ppcg,no|build|bundled|system,bundled)
AX_SUBMODULE_FWD(isl,build|bundled|system,bundled)
AX_SUBMODULE_FWD(pet,build|bundled|system,bundled)
AX_SUBMODULE_FWD(clang,build|system,system)
case "$with_ppcg" in
no)
	;;
bundled)
	PPCG_BUILDDIR="${abs_builddir}/ppcg"
	PPCG_SRCDIR="${abs_srcdir}/ppcg"
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
AX_SUBMODULE(pencil,no|build|bundled|system|no,bundled)
case "$with_pencil" in
no)
	;;
bundled)
	PENCIL_BUILDDIR="${abs_builddir}/pencil"
	PENCIL_SRCDIR="${abs_srcdir}/pencil"
	;;
build)
	PENCIL_BUILDDIR=`echo @abs_builddir@ | $with_pencil_builddir/config.status --file=-`
	PENCIL_SRCDIR=`echo @abs_srcdir@ | $with_pencil_builddir/config.status --file=-`
	;;
system)
	;;
esac
AM_CONDITIONAL(BUNDLED_PENCIL, test "x$with_pencil" = xbundled)

dnl Prefer manually downloaded Scala+Antlr3 over autodetected
if test -f "${abs_srcdir}/scala/lib/scala-compiler.jar"; then
	CLASSPATH="${CLASSPATH}:${abs_srcdir}/scala/lib/scala-compiler.jar"
fi
if test -f "${abs_srcdir}/scala/lib/scala-library.jar"; then
	CLASSPATH="${CLASSPATH}:${abs_srcdir}/scala/lib/scala-library.jar"
fi
if test -f "${abs_srcdir}/scala/lib/scala-reflect.jar"; then
	CLASSPATH="${CLASSPATH}:${abs_srcdir}/scala/lib/scala-reflect.jar"
fi
if test -f "${abs_srcdir}/antlr3/antlr3.jar"; then
	CLASSPATH="${CLASSPATH}:${abs_srcdir}/antlr3/antlr3.jar"
fi
if test -f "${abs_srcdir}/antlr3/ant-antlr3.jar"; then
	CLASSPATH="${CLASSPATH}:${abs_srcdir}/antlr3/ant-antlr3.jar"
fi
if test -f "${abs_srcdir}/scala/bin/scala"; then
	subconfigure_addargs="${subconfigure_addargs} SCALA=${abs_srcdir}/scala/bin/scala"
fi
if test -f "${abs_srcdir}/scala/bin/scaladoc"; then
	subconfigure_addargs="${subconfigure_addargs} SCALADOC=${abs_srcdir}/scala/bin/scaladoc"
fi

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
	ac_configure_args="${ac_configure_args} CLASSPATH=${CLASSPATH} ${subconfigure_addargs} --with-ocl_utilities=${oclutilities_path}" 
])
AC_OUTPUT
