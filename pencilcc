#! /usr/bin/env bash

# Influential environment options:
#   CPP
#   CPPFLAGS
#   CC
#   CFLAGS
#   PPCG
#   PPCG_FLAGS
#   PENCILOPTIMIZER
#   PENCILOPTIMIZER_FLAGS


# Print help screen 
function show_help() {
  echo help
}


# Echo this message to stderr if verbose is activated
function print_verbose {
  if [ ${verbose} = yes ]; then
    >&2  echo "$*" 
  fi
}


# Execute the command
# Print it on screen if verbose is on
function exec {
  cmdline="\$"
  whitespace="[[:space:]]"
  for arg in "$@"; do
    #TODO: Escape quotes inside $arg
   #arg=${${arg}/'/'\''} 
    if [[ "$arg" =~ $whitespace ]]; then 
      arg="'$arg'"
	fi
    cmdline="${cmdline} ${arg}"
  done
  print_verbose "${cmdline}"

  # Allow the expansion of the first argument (the command)
  # Otherwise, home-relative paths don't work (~/bin/cc)
  # This way also command arguments can be passed as first argument (CPP=gcc -E)
  $(eval echo $1) "${@:2}"
}


function invoke_cpp() {
  exec "${CPP}" ${CPPFLAGS} "$@"
}

function invoke_cc() {
  #TODO: Configure of those should be passed
  #TODO: -Wno-unknown-pragmas -Wno-unused-function are gcc-specific
  exec "${CC}" -Wno-unknown-pragmas -Wno-unused-function ${CPPFLAGS} ${CFLAGS} "$@"
}

function invoke_ppcg() {
  exec "${PPCG}" ${PPCG_FLAGS} "$@"
}

function invoke_optimizer() {
  exec "${PENCILOPTIMIZER}" ${PENCILOPTIMIZER_FLAGS} "$@"
}


# Environment default values
if [ -z "${CPP}" ]; then
  CPP=cpp
fi

if [ -z "${CC}" ]; then
  CC=cc
fi

if [ -z "${PPCG}" ]; then
  PPCG=ppcg
fi

if [ -z "${PENCILOPTIMIZER}" ]; then
  PENCILOPTIMIZER=pencil-optimizer
fi



# Verbose output to stderr
verbose=no

# Use ppcg for .pencil.c files
toolchain_ppcg=no

# Use pencil-optimizer for .pencil.c files
toolchain_optimizer=no

cpp_args=
cc_args=

input_files=


addccarg=no
argno=0
for arg in "$@"; do
  addarg=no
  case "$arg" in

  -h|--help)
    show_help
    exit 0
    ;;

  -v|--verbose)
    verbose=yes
    addcpparg=yes # Also let compiler output verbose
    ;;

  --pencil-verbose)
    verbose=yes
    ;;

  --pencil-cc=*)
    CC=`echo A$arg | sed -e 's/A--pencil-cc=//g'`
    ;;

  --pencil-ppcg=*)
    PPCG=`echo A$arg | sed -e 's/A--pencil-ppcg=//g'`
    ;&
  --pencil-ppcg)
    toolchain_ppcg=yes
    ;;

  --pencil-optimizer=*)
    PENCILOPTIMIZER=`echo A$arg | sed -e 's/A--pencil-optimizer=//g'`
    ;&
  --pencil-optimizer)
    toolchain_optimizer=yes
    ;;

  *.pencil.c) # Input file
    if [ -f "$arg" ]; then
      # It is a file which exists
      # Interpret as input argument
      pencil_files=("${pencil_files[@]}" "$arg")
    else
      # Interpret as compiler argument
      addccarg=yes
    fi
    ;;

  *)
    if [ -f "$arg" ]; then
      input_files=("${files[@]}" "$arg")
    else
      addccarg=yes
    fi
    ;;
  
  esac
  if [ $addccarg == yes ]; then
    cc_args=("${cc_args[@]}" "$arg")
  fi
  ((argno++))
done


files=("${input_files[@]}")
tmppath=$(mktemp -dt pencil.XXXXX)

if [ ${toolchain_ppcg} = yes ]; then

  i=0
  for infile in "${files[@]}"; do
    autodetect_flags=
    if [ "${infile}" = *.pencil.c ]; then
      autodetect_flags=--pet-autodetect
    fi

    subfolder=$(mktemp -p ${tmppath} -dt ppcg.XXXXX)
    outfile="${subfolder}/$(basename "${infile}" .c).ppcg.c"
    invoke_ppcg --target=opencl --opencl-embed-kernel-code ${autodetect_flags} "${infile}" -o "${outfile}"

    files[$i]="${outfile}"
    ((i++))
  done
fi

./cmdline.sh "${files[@]}"
invoke_cc "${cpp_args[@]}" "${cc_args[@]}" "${files[@]}"
