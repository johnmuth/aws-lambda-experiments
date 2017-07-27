import json
import logging

logging.basicConfig()
logger = logging.getLogger('dynamodb_trigger_1')
logger.setLevel(logging.DEBUG)

def get_dynamodb_item_attribute(event, attribute):
    if 'Records' not in event:
        return None
    for record in event['Records']:
        if 'dynamodb' not in record or 'Keys' not in record['dynamodb'] or attribute not in record['dynamodb']['Keys']:
            return None
        return record['dynamodb']['Keys'][attribute]['S']

def handler(event, context):
    logger.debug('event: %s', json.dumps(event))
    foo = get_dynamodb_item_attribute(event, 'Foo')
    logger.debug('foo: %s', json.dumps(foo))
