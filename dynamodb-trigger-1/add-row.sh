#!/usr/bin/env bash

usage() { echo "Usage: $0 -f <foo>" 1>&2; exit 1; }

while getopts ":f:" o; do
    case "${o}" in
        f)
            foo=${OPTARG}
            ;;
        *)
            echo "Unrecognized option ${o} ${OPTARG}"
            usage
            ;;
    esac
done

if [ -z "${foo}" ] ; then
  usage
fi

set -e
set -u

itemJSON="{ \"Foo\": { \"S\": \"$foo\" } }"

aws dynamodb put-item --table-name DynamodbTrigger1Table --item "$itemJSON"

