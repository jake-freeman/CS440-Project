# CS440-Project
Final Project for CS 440 - Illinois Institute of Technology

 - Jacob Freeman
 - Andrew Viverito
 - Max Burns

## How to run

### Dependencies
 - YACC
 - LEX
 - Linux Environment (tested in Ubuntu 14.04, Kernel version 3.13.0-74-generic)
 - gcc

On Ubuntu the relevant dependencies can be installed with:

```
sudo apt-get install build-essential byacc flex
```

### Building and running

#### Quick Start

The quickest way to build and run is running the following commands:

```
./build.sh
./test.sh $YOUR_C_FILE
```

You can also run the parser directly by running `./c_lang`, which takes input via stdin

The type checker can be run directly by running `./c_langCheck`, which also takes input via stdin

### Build Options

You can also cleanup the build files by running `./clean.sh`
