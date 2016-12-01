#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Error: Needs file argument"
  exit 1
fi


./c_lang < $1 && \
echo && echo && echo "Type Checker Output:" && echo && \
./c_langCheck < $1 && \
echo && echo "No type mismatches!"
