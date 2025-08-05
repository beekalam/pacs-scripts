#!/usr/bin/env bash

# example usage
# sudo find ~+ -type f -name '*.dcm' -exec PATH-TO/dcmreplace.sh -t "PatientName" -i "(0010,0010)" -f {} \;
function usage ()
{
    printf "usage: %s [-f 'file'] [-t 'tag'] [-i 'tagid' ] \n" ${0##*/} >&2
    exit
}


while getopts 'f:t:i:h' argv
do
    case $argv in
	      f) file=$OPTARG
	         ;;
	      t) tag=$OPTARG
	         ;;
        i) tagid=$OPTARG
           ;;
	      h) usage
	         ;;
    esac
done
shift $((OPTIND - 1))

if [ -z "$file" ]
then
       echo "file not provided."
       usage
fi
if [ -z "$tag" ]
then
    echo "tag not provided."
    usage
fi
if [ -z "$tagid" ]
then
    echo "tagid not provided."
    usage
fi

tagvalue=`dcmdump "$file" | grep "$tag" | cut -d "[" -f2 | cut -d "]" -f1`
dcmodify -e "$tagid" "$file"
dcmodify -i "$tagid=$tagvalue" "$file"
echo "replaced $tag in $file"

