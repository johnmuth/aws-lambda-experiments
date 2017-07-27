# dynamodb-trigger-1

Say you have a lambda function that you configure to be triggered by DynamoDB events: add a row to the DynamoDB table, and the lambda runs.

What happens if the row you write to the DynamoDB table is identical to a row that's already there?

I assumed it would run, but I think I've seen times when it did not, so I want to test it.

## create the s3 bucket for the lambda zip
 
 ```
 aws s3 mb s3://aws-lambda-experiments
 ```

## package the lambda

```
$ ./package.sh
```

## upload the lambda zip to s3

```
$ ./upload-lambda.sh
```

## create cloudformation stack

```
$ ./create-stack.sh
```

## add row to table

```
$ ./add-row.sh -f bar
```

## see output from lambda

## add identical row to table

```
$ ./add-row.sh -f bar
```

## see output from lambda?



