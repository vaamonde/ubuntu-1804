#!/bin/bash

for a in $(find . -name '*.sln16'); do
  sox -t raw -e signed-integer -b 16 -c 1 -r 16k $a -t gsm -r 8k `echo $a|sed "s/.sln16/.gsm/"`;\
  sox -t raw -e signed-integer -b 16 -c 1 -r 16k $a -t raw -r 8k -e a-law `echo $a|sed "s/.sln16/.alaw/"`;\
  sox -t raw -e signed-integer -b 16 -c 1 -r 16k $a -t raw -r 8k -e mu-law `echo $a|sed "s/.sln16/.ulaw/"`;\
done
