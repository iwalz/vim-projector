vim-projector
=============

Projector is a small plugin, allowing you to map "project specific shortcuts" to vim. 
For example a command to compile the project you're currently working on. Those commands vary from project to 
project. So a "global vim mapping" is not really useful for those use-cases. 

Installation
------------

The recommended way to install projector is to use `pathogen`.

```
cd ~/.vim/bundle
git clone git://github.com/iwalz/projector.git
```

How it works
------------

This plugin adds and reads files named `.projector` in your project. These files look like this:

```
COMPILE=gcc -g -o foo foo.c
RUN=./foo
DEBUG=gdb ./foo
CUSTOM1=make test
CUSTOM2=make clean
CUSTOM3=
```

The specified commands are bound to the directory, where your .projector file is placed. So it switches the working
directory to this directory before executing the commands and switches back to the previous working dir once the command is done.

Those 6 project specific commands are bound to the following keys by default:

```
RUN     = <F5>
COMPILE = <F6>
DEBUG   = <F8>
CUSTOM1 = <F9>
CUSTOM2 = <F10>
CUSTOM3 = <F11>
```

If you want to change the mappings, simply add those lines to your `.vimrc`:

```
let g:projector_run_shortcut = "<C-5>"
let g:projector_compile_shortcut = "<C-6>"
let g:projector_debug_shortcut = "<C-8>"
let g:projector_custom1_shortcut = "<C-9>"
let g:projector_custom2_shortcut = "<C-0>"
let g:projector_custom3_shortcut = "<ß>"
```

All mappings are available in insert and normal mode. 

Registered commands
-------------------

*:CreateProjector*

Creates a `.projector` file in the current working dir of vim

*:EditProjector*

Edit the `.projector` file.

*:CreateProjectorFile*

Creates a `.projector_$filename` file for the current file. The specified mappings only work in this file.

*:ReloadProjector*

Refreshes the projector commands - execute it, if you've changed the `.projector` commands and you don't want to restart vim.

The structure
-------------

A regular directory structure might look like this:

```
projectroot
   src/
      component1/
          foo.c
      component2/
          bar.c
      component3/
          baz.c
          blubb.c
   test/
   doc/
```

Let's say we add a few .projector files (this is an unusual amount if files I'm going to add - simply to explain the behaviour):

```
projectroot
   .projector
   src/
      component1/
          .projector
          foo.c
      component2/
          .projector
          bar.c
      component3/
          .projector
          .projector_blubb.c
          baz.c
          blubb.c
   test/
   doc/
```

So let's explain how it works. The commands, defined in `projectroot/.projector` are available everywhere below `projectroot/` - 
unless they're overriden in a subdirectory. If you open for example `projectroot/src/component1/foo.c` and _only_ *CUSTOM1* is overriden
in `projectroot/component1/.projector`, the mapping for *CUSTOM1* will change, everything else not. So it's all about the priority, depending
 on where your current file is in the hierarchy.
