#! /bin/sh
# v.2019-01-05 sets folder's date to match its oldest file's date.
# Solves the problem with folders having a latter Date Modified in macOS,
# making it difficult to upload them to Photos.app in order

#SYNTAX: dirdatephoto.sh DIR -a

case $1 in
  .) dir="$(pwd)";;
 '') echo help; exit;;
  *) dir="$1";;
esac

case $2 in
  -a|all) echo $2; for d in */ ; do ~/dirdatephoto.sh "$(pwd)"/"$d"; done; exit;;
  *) ;;
esac

#select first file in directory
#dir=$1
pierw=$(ls -rt "$dir" | sed 1q)

#determine its Date Modified and put in var
isdt=$(stat -l -t '%y%m%d%H%M.%S' "$dir"/"$pierw" | cut -f6 -d ' ')

#set folder's Date Modified using that var
touch -t "$isdt" "$dir" #[[CC]YY]MMDDhhmm[.SS]'
echo "ok. date now $isdt for \"$dir\", matches "$pierw""
 
