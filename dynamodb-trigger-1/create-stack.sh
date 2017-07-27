#!/usr/bin/env bash

set -e
set -u

echo "Creating stack"

aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM --stack-name dynamodb-trigger-1-stack --template-body file://cloudformation.json

echo "Waiting for stack to be ready"

aws cloudformation wait stack-create-complete --stack-name dynamodb-trigger-1-stack

echo "Ready!"
