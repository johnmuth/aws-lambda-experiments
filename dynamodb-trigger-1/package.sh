#!/usr/bin/env bash

set -e
set -u

(
  cd dynamodb-trigger-1
  zip -r -X "../dynamodb-trigger-1.zip" *
)


