#!/bin/bash

echo "Please Enter your password"
read -s "password"    #here password is variable and it is storing the value, read is reading the value and
# -s is it will not display the entered value in cmd
echo "Password is $password"