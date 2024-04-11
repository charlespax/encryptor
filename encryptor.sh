#!/bin/bash

print_usage() {
    #echo "encryptor -i <input filename> -o <output filename>"
    echo "encryptor -i <input filename>"
    echo "  -i   input filename"
    echo "  -h   PRINT This help message"
    echo "  -q   PRINT qr code if qrencode is installed"
    # TODO support output file name
    #echo "  -o   output filename"
}

encrypt() {
    # TODO Spilt this into two functions:
    #  1. generate encrypted string
    #  2. create the output file
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
}

print_qrcode() {
    cat $OUT_FILE | qrencode -s 1 -t ansiutf8
}

while getopts 'hi:q' flag; do
  case "${flag}" in
    h) print_usage
       exit 1 ;;
    i) IN_FILE="${OPTARG}" ;;
#    o) OUT_FILE="${OPTARG}" ;;
    q) q_flag='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

# TODO execute this only if the input file is given
# TODO if no output file is given, output text to terminal
encrypt

# TODO Do not display qrcode if encrypt function fails
# TODO if no output file is given, display only qr code
if [ "$q_flag" == "true" ]
then
    print_qrcode
fi
