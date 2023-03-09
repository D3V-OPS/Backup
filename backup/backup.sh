#!/bin/bash

HOST=root@hostname
SOURCE=/home/dev/testing
TARGET=/home/dev/test
DAYS=7 

if [ ! -d $SOURCE ]; then
        mkdir -p $SOURCE;
fi 
echo --- required directory has been successfully created ---
echo
cd $SOURCE;
for i in {0..11}; do
        base64 /dev/urandom | head -c 10M> $i.test.txt
done
echo Random files have been generated!
echo

echo Begin transtitting files...
rsync -avz $SOURCE/*test.txt $HOST:$TARGET
echo
echo Files has been successfully transmitted!


echo Find and clean obsolete files on remote host machine 
rsync -avz --files-from=<(ssh $HOST "find $TARGET -mtime +$DAYS -exec rm -v '{}' \;") $HOST:$TARGET $TARGET
echo Old files has been successfully erased!
echo 
echo 
echo "--- ГОТОВО! =) ---"

