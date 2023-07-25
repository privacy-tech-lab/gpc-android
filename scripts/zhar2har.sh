#!/bin/bash

mkdir -p zhar_done/
mkdir -p har/

for f in zhar/*.zhar; do
    f="${f%.*}"
    mv $f.zhar $f.zz
    pigz -k -d -z $f.zz
    
    mv $f $f.json
    mv $f.json har/

    mv $f.zz $f.zhar
    mv $f.zhar zhar_done/
done

# repeat for hidden files
for f in zhar/.*.zhar; do
    f="${f%.*}"
    mv $f.zhar $f.zz
    pigz -k -d -z $f.zz
    
    mv $f $f.json
    mv $f.json har/

    mv $f.zz $f.zhar
    mv $f.zhar zhar_done/
done

