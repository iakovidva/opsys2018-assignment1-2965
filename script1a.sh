#! /bin/bash

IFS=$'\n' read -d '' -r -a lines < sites.txt
counter=${#lines[@]}

for(( i=0; i<$counter; i++ ))
do
    site=${lines[i]}
    if [[ $site == \#* ]]
    then
	    continue
    fi
    wget -q -O code$i.txt $site
    md5sum code$i.txt | cut -c -32 > code$i.md5
    if [ $? -ne 0 ]
    then
	    echo "$site FAILED"
	    cat FAILED > backup$i.md5
    fi
    if [ -e "backup$i.md5" ]
    then
        if [ $(cat code$i.md5) != $(cat backup$i.md5) ]
        then
            echo "$site"
            cat code$i.md5 > backup$i.md5
        fi
    else
        cat code$i.md5 > backup$i.md5
        echo "$site INIT"
    fi
    rm code$i.txt
    rm code$i.md5
done
