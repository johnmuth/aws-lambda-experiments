# dynamodb-trigger-1

I have a lambda function configured to be triggered by DynamoDB events: whenever a row is added to the DynamoDB table, the lambda runs with the content of the row as input.

What happens if I do two writes with the same data? Would the lambda be triggered twice?

I assumed it would, but I could swear I've seen times when it did not, but I'm not sure, so I want to test it.

**TL;DR: The lambda is only triggered once. Writing identical data to a DynamoDB table multiple times does not fire multiple DynamoDB events.**

## What's in this folder

#### 1. the lambda function

[./dynamodb-trigger-1/dynamodb_trigger_1.py](./dynamodb-trigger-1/dynamodb_trigger_1.py)

It doesn't do much:

* reads the DynamoDB Event object provided to it when it's invoked by the trigger,
* logs the value of "Foo"

#### 2. the cloudformation.json

[./cloudformation.json](./cloudformation.json)

It includes the DynamoDB table definition and the association between it and the lambda.

I'm pretty sure it's the absolute minimum configuration of everything required to make this work.

## Running the experiment

#### 1. package and upload the lambda function

The cloudformation.json specifies that it should get the lambda code from an S3 bucket, so create it:
 
```bash
 aws s3 mb s3://aws-lambda-experiments
 ```

Create the lambda zip package.

```bash
( cd dynamodb-trigger-1 && zip -r -X "../dynamodb-trigger-1.zip" * )
```

Upload it to s3

```bash
aws s3 cp dynamodb-trigger-1.zip s3://aws-lambda-experiments
```

#### 2. create the cloudformation stack

This action creates the table, deploys the lambda, and configures everything so the one can trigger the other.

```bash
aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM \
  --stack-name dynamodb-trigger-1-stack --template-body file://cloudformation.json && \
  aws cloudformation wait stack-create-complete --stack-name dynamodb-trigger-1-stack
```

#### 3. add a row to the table

```bash
aws dynamodb put-item --table-name DynamodbTrigger1Table --item '{ "Foo": { "S": "bar" } }'
```

#### 4. check the lambda logs

```bash
logStreamName=`aws logs describe-log-streams --log-group-name '/aws/lambda/DynamodbTrigger1' | jq -r '.logStreams[-1].logStreamName'`
aws logs get-log-events --log-group-name '/aws/lambda/DynamodbTrigger1' --log-stream-name "$logStreamName" | jq -r '.events[].message'
```

You should see a line like:

```bash
[DEBUG]	2017-07-28T06:05:20.456Z	15845ebd-1be0-4cdc-b4c3-7265bb780f51	foo: "bar"
```

#### 4. Add the same row again, check the logs again

*(Repeat "add row to table" command above.)*

*(Repeat "Check lambda logs" command above.)*

The lambda is not triggered by adding the same data after the first time.

## Cleaning up

```bash
aws cloudformation delete-stack --stack-name dynamodb-trigger-1-stack && \
  aws cloudformation wait stack-delete-complete --stack-name dynamodb-trigger-1-stack
```
