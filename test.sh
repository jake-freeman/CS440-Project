#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Error: Needs file argument"
  exit 1
fi

<<<<<<< HEAD
./c_lang < $1 && \
echo && echo && echo "Type Checker Output:" && echo && \
./c_langCheck < $1 && \
echo && echo "No type mismatches!"
=======
./c_lang < $1

./c_langCheck < $1
>>>>>>> 1565ba57e838b52ee60b72f43b2f26c5f1b68436
