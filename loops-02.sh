#!/bin/bash

allItems=("Banana" "Apple" "Grapes")

# for loops or (for in loop)
for item in "${allItems[@]}"
    do 
    echo "Items :: $item"
    done


    # while loop

    num=1
    while [ $num -le 5 ];
    do 
    echo "Number:: $num"
    $num=$(($num+1))
    done