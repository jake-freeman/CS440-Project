# CS440-Project
Final Project for CS 440 - Illinois Institute of Technology

## How to run

### Dependencies
 - YACC
 - LEX
 - Linux Environment (tested in Ubuntu 14.04, Kernel version 3.13.0-74-generic)
   - May also work in OS X / macOS
 - Make
 - gcc

On Ubuntu the relevant dependencies can be installed with:

```
sudo apt-get install build-essential byacc flex
```

### Building and running

#### Quick Start

The quickest way to build and run is running the following commands:

```
make
./test.sh $YOUR_C_FILE
```

You can also run the compiler directly by running `./c_lang`, which takes input via stdin

### Build Options

There are a few extra make targets that may be useful
 - `make run` - Build and then run with input taken from `test.c` (you need to make this file)
 - `make debug` - Build with YACC's debug mode enabled to get verbose output during parsing
 - `make run_debug` - Similar to `make run` but using the debug version from above
 - `make clean` - Delete all the junk made my YACC, Lex, and GCC
