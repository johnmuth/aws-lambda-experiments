#!/usr/bin/env bash

set -e
set -u

echo "Deleting stack"

aws cloudformation delete-stack --stack-name dynamodb-trigger-1-stack

echo "Waiting for stack to be deleted"

aws cloudformation wait stack-delete-complete --stack-name dynamodb-trigger-1-stack

echo "Deleted!"
