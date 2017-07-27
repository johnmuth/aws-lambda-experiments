#!/usr/bin/env bash

set -e
set -u

aws s3 cp dynamodb-trigger-1.zip s3://aws-lambda-experiments


