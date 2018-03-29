#!/bin/bash

IN_FILE=$1
GPG_FILE="$IN_FILE.gpg"
OUT_FILE="$IN_FILE.out.sh"

gpg -o $GPG_FILE -c $IN_FILE

echo "#!/bin/bash" > $OUT_FILE
echo >> $OUT_FILE
echo -n "echo " >> $OUT_FILE
base64 --wrap=0 $GPG_FILE >> $OUT_FILE
echo " | base64 -d | gpg -o out.txt" >> $OUT_FILE

# Clean up
rm $GPG_FILE

