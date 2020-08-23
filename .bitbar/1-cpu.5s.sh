#!/bin/sh
ps c -Ao command,pcpu -r | awk 'NR>1' | head -n 1 | /usr/local/bin/rg -o '^(\w+)[^\d]*([\.\d]+)$' -r '$1 $2%'
