#!/bin/bash


#In linux server while running script we need to pass values , as the * and @ will hold the values
echo "These are special variables we can use * $*"
echo "These are special variables we can use @ $@"

# $0 will give the executing script name 
echo "$0   this will give the executing script name"

echo "current directory : $PWD"
echo "current directory : $pwd"

echo "current USER : $USER"
echo "home directory : $HOME"

echo "Process instance id or PID for the running script: $$"


