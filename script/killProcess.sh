#!/bin/bash
usage() {
  echo "Usage: sh $0 process_keyword..."
  echo "Eg. sh $0 key1 key2..."
}
if [ $# -lt 1 ] || [ "$1" = "-h" ]; then
  usage
  exit 1
fi
PRO="ps -ef|grep $USER|grep -v grep|grep -v $0"
for i in "$@"; do
  PRO=${PRO}"|grep $i"
done
eval "$PRO" | while read -r u pid o; do
  for i in $pid; do
    echo "Kill the process [ $i ]"
    kill -9 "$i"
  done
done
