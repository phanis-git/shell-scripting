#!/bin/bash

# here we can use $@ or $* for dynamic sending of values while in script run command
# ex:- sh fileName.sh mysql node mysql-server

allPackages=$@
for package in $allPackages
do 
echo "Package Name:: $package"
done