#!/bin/bash
a=`ls /usr/share/vim/vimcurrent | awk '{print $NF}'`
b=`ls -al /usr/share/vim/ | grep "vimcurrent" | awk '{print$NF}'`
echo $b

