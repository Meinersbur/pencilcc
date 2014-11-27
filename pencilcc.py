#! /usr/bin/env python3
# -*- coding: UTF-8 -*-

import argparse
import os
import subprocess
import shlex
import tempfile
import sys # sys.stderr


### Global options

# Print executed commands
print_commands = False

# Paths to programs to call

cpp_prog = 'cpp'
cpp_flags = []
cpp_verbose = 0

optimizer_prog = 'pencil-optimizer'
optimizer_flags = []
optimizer_verbose = 0

ppcg_prog = 'ppcg'
ppcg_flags = []
ppcg_verbose = 0

cc_prog = 'cc'
cc_flags = []
cc_verbose = 0


def invoke(cmd, *args):
	if print_commands:
		shortcmd = os.path.basename(cmd) if print_commands_baseonly else shlex.quote(cmd)
		print('$ ' + shortcmd + ' ' + ' '.join([shlex.quote(s) for s in args]),file=sys.stderr)
	subprocess.check_call([cmd] + list(args))


def verbosity(lvl):
	if lvl > 0:
		return ['-' + 'v'.repeat(lvl)]
	return []


def call_cpp(*args):
	invoke(cpp_prog, *args)
def invoke_cpp(*args):
	allargs = verbosity(cpp_verbose)
	allargs += cpp_flags
	allargs += args
	call_cpp(*allargs)

def call_ppcg(*args):
	invoke(ppcg_prog, *args)
def invoke_ppcg(*args):
	allargs = verbosity(ppcg_verbose)
	allargs += ppcg_flags
	allargs += args
	call_ppcg(*args)

def call_optimizer(*args):
	invoke(optimizer_prog, *args)
def invoke_optimizer(*args):
	allargs = []
	if optimizer_verbose:
		allargs += ['-dump-passes']
	allargs += optimizer_flags
	allargs += args
	call_optimizer(*allargs)

def call_cc(*cmdline):
	invoke(cc_prog, *cmdline)
def invoke_cc(*cmdline):
	extra_flags = verbosity(cc_verbose)
	extra_flags += cc_flags
	extra_flags += cmdline
	call_cc(*extra_flags)


def print_versions():
	print("PENCIL driver version 0.1")
	print()
	
	if cpp_prog:
		print("cpp:", cpp_prog)
		try:
			call_cpp('--version')
		except:
			pass
		
	if optimizer_prog:
		print("optimizer: ", optimizer_prog)
		try:
			call_optimizer('--version')
		except e:
			pass

	if ppcg_prog:
		print("ppcg: ", ppcg_prog)
		try:
			call_ppcg('--version')
		except:
			pass

	if cc_prog:
		print("cc: ", cc_prog)
		try:
			call_cc('--version')
		except:
			pass


def main():
	CC = os.environ.get('CC')
	CPP = os.environ.get('CPP')
	
	CFLAGS = shlex.split(os.environ.get('CFLAGS') or '')
	CPPFLAGS = shlex.split(os.environ.get('CPPFLAGS') or '')

	parser = argparse.ArgumentParser(description="Driver for PENCIL.  Executes pencil-optimizer, ppcg and compiler as required.")
	parser.add_argument('-v', '--verbose', action='count', default=0)
	parser.add_argument('--version', action='store_true', help="Print versions of involved programs")
	parser.add_argument('--show-commands', action='store_true', help="Print executed commands")
	parser.add_argument('--show-commands-baseonly', action='store_true', help="Do not print full command path")
	
	parser.add_argument('--pencil-cpp-path', metavar='CC', default=CPP or 'cpp')
	
	parser.add_argument('--pencil-opt', action='store_true', default=False, help="Use pencil-optimizer in toolchain")
	parser.add_argument('--pencil-opt-path', metavar='OPTIMIZER', help="Path to optimizer")
	
	parser.add_argument('--pencil-ppcg', action='store_true', default=False, help="Use ppcg in toolchain")
	parser.add_argument('--pencil-ppcg-path', metavar='PPCG', help="Path to ppcg")
	
	parser.add_argument('--pencil-cc-path', metavar='CC', default=CC or 'cc')

	parser.add_argument('--pencil-runtime', action='store_true', help="Use the PENCIL OpenCL runtime")

	known, unknown = parser.parse_known_args() # Beware of prefix matching: https://mail.python.org/pipermail/python-dev/2013-November/130601.html http://bugs.python.org/issue14910
	print(known)


	global print_commands,print_commands_baseonly
	print_commands = (known.verbose > 0) or known.show_commands or known.show_commands_baseonly
	print_commands_baseonly = known.show_commands_baseonly
	
	global cpp_prog,cpp_flags,cpp_verbose
	cpp_prog = known.pencil_cpp_path or CPP or cpp_prog
	cpp_flags = CPPFLAGS
	cpp_verbose = max(cpp_verbose, known.verbose - 1)
	
	global optimizer_prog,optimizer_flags,optimizer_verbose
	optimizer_prog = known.pencil_opt_path or optimizer_prog
	optimizer_verbose = max(optimizer_verbose, known.verbose-1)
	
	global ppcg_prog,ppcg_verbose 
	ppcg_prog = known.pencil_ppcg_path or ppcg_prog
	if known.verbose > 1:
		ppcg_verbose = known.verbose - 1
	
	global cc_prog,cc_flags,cc_verbose
	cc_prog = known.pencil_cc_path or cc_prog
	cc_flags = [] + CPPFLAGS + CFLAGS
	if known.verbose > 1:
		cc_verbose = known.verbose - 1
	
	use_ppcg = known.pencil_ppcg or known.pencil_ppcg_path
	use_optimizer = known.pencil_opt or known.pencil_opt_path
	use_runtime = known.pencil_runtime
	
	ocl_utilities_h_path = os.path.combine(os.path.abspath(ppcg_prog), '..', 'ocl_utilities.h')
	
	if known.version:
		print_versions()
		exit(0)

	
	files = []
	ccargs = []
	
	for arg in unknown:
		if os.path.isfile(arg):
			files.append(arg)
		else:
			ccargs.append(arg)
		
	print("Input files:", files)
	print("No special handling for (passed to cc):", ccargs)
	
	if not files:
		print("No input files")
		exit(4)
	
	#with tempfile.TemporaryDirectory(prefix='pencil.') as tmpdir:
	tmpdir = tempfile.mkdtemp(prefix='pencil.')
	while True:
		outfiles = []
		for infile in files:
			ispencil = infile.endswith('.pencil.c')
			basename = os.path.basename(infile)
			rootname = os.path.splitext(basename)[0]
			file = infile
			
			if use_optimizer and ispencil:
				cppfile = tempfile.mkstemp(prefix=rootname,postfix='.i',dir=tmpdir)
				invoke_cpp('-P','-o', cppfile)

				optfile = tempfile.mkstemp(prefix=rootname,postfix='.opt.c',dir=tmpdir)
				invoke_opt(cppfile,'-o',optfile)
				file = optfile
			
			if use_ppcg:
				tmpsubdir = tempfile.mkdtemp(prefix='ppcg.',dir=tmpdir)
				outfile = os.path.join(tmpsubdir, basename)
				ppcgargs = ['--target=opencl']
				if ispencil:
					ppcgargs += ['--pet-autodetect']
				ppcgargs += [file, '-o', outfile]
				invoke_ppcg(*ppcgargs)
				file = outfile
				
			outfiles.append(file)

		invoke_cc(*(['-std=c99'] + ccargs + outfiles))
		break


if __name__ == '__main__':
	main()






