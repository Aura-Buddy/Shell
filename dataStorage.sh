#!/bin/sh
a=0  
while [ $a -lt $1 ]
do 
    # Print the values
    echo $a      
    # increment the value
    a=`expr $a + 1`
    echo $(date) >> data.txt
done
