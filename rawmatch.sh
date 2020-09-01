#! /bin/sh
# v.2019-01-19 deletes raw files if matching jpg was deleted.
# Solves the problem with bad raw files being kept needlessly.
# Combines speed of previewing jpg with quality of RAW editing.
# DEPENDENCIES: Trash (brew install trash)

#SYNTAX: rawmatch.sh DIR

cd "$1"

for RW2 in *.RW2
do
    plain="${RW2%.*}" #withot extension
    JPG="$plain".JPG #jpg file with the same base name

	if [ ! -f "$JPG" ]; then
	    echo "$JPG not found! - deleting $RW2"
            trash "$RW2"
	fi

done
exit
