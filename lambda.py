import boto3
import os

PROJECT_NAME = os.environ['CODEBUILD_PROJECT_NAME']

codebuild = boto3.client('codebuild')


def start_build(**kwargs):
    response = codebuild.start_build(**kwargs)
    if response['ResponseMetadata']['HTTPStatusCode'] != 200:
        raise Exception('ERROR: {}'.format(response))
    return response['build']


def lambda_handler(event, context):
    print('Event: {}'.format(event))
    print('Starting {} build'.format(PROJECT_NAME))
    build = start_build(projectName=PROJECT_NAME)
    print('Started build {}'.format(build['id']))
