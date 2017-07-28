# dynamodb-trigger-1

I have a lambda function configured to be triggered by DynamoDB events: whenever a row is added to the DynamoDB table, the lambda runs with the content of the row as input.

What happens if I do two writes with the same data? Would the lambda be triggered twice?

I assumed it would, but I could swear I've seen times when it did not, but I'm not sure, so I want to test it.

**TL;DR: The lambda is only triggered once. Writing identical data to a DynamoDB table multiple times does not fire multiple DynamoDB events.**

## create the s3 bucket for the lambda zip
 
```bash
 aws s3 mb s3://aws-lambda-experiments
 ```

## package the lambda

```bash
( cd dynamodb-trigger-1 && zip -r -X "../dynamodb-trigger-1.zip" * )
```

## upload the lambda zip to s3

```bash
aws s3 cp dynamodb-trigger-1.zip s3://aws-lambda-experiments
```

## create cloudformation stack

```bash
aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM \
  --stack-name dynamodb-trigger-1-stack --template-body file://cloudformation.json && \
  aws cloudformation wait stack-create-complete --stack-name dynamodb-trigger-1-stack
```

## add row to table

```bash
aws dynamodb put-item --table-name DynamodbTrigger1Table --item '{ "Foo": { "S": "bar" } }'
```

## Check lambda logs

```bash
logStreamName=`aws logs describe-log-streams --log-group-name '/aws/lambda/DynamodbTrigger1' | jq -r '.logStreams[-1].logStreamName'`
aws logs get-log-events --log-group-name '/aws/lambda/DynamodbTrigger1' --log-stream-name "$logStreamName" | jq -r '.events[].message'
```

You should see a line like:

```bash
[DEBUG]	2017-07-28T06:05:20.456Z	15845ebd-1be0-4cdc-b4c3-7265bb780f51	foo: "bar"
```

## Add same row to table again, check logs again

*(Repeat "add row to table" command above.)*
*(Repeat "Check lambda logs" command above.)*

The lambda is not triggered by adding the same data after the first time.

## Delete stack

```bash
aws cloudformation delete-stack --stack-name dynamodb-trigger-1-stack && \
  aws cloudformation wait stack-delete-complete --stack-name dynamodb-trigger-1-stack
```
