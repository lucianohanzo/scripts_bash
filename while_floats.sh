#!/bin/bash

Nu=1.11144
Max=10.567

Cond=$(bc <<< "$Nu < $Max")

while [ $Cond == 1 ]; do
    echo "Número : $Nu"
    Nu=$(bc <<< "$Nu + 1.33")
    Cond=$(bc <<< "$Nu < $Max")
done


