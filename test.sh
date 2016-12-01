#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Error: Needs file argument"
  exit 1
fi

./c_lang < $1

./c_langCheck < $1
