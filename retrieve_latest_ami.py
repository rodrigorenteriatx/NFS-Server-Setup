import boto3
import json
import os

def get_ami_id():
    client = boto3.client('ec2')

    response = client.describe_images(
        Filters=[
            {
                'Name': 'description',
                'Values': [
                    'Amazon Linux 2023 AMI*',
                ]
            },
            {
                'Name': 'architecture',
                'Values': [
                    'x86_64',
                ]
            },
            {
                'Name': 'block-device-mapping.volume-size',
                'Values': [
                    '8',
                ]
            }
        ]
        ,
        Owners=[
            'amazon',
        ],
    )

    # print(json.dumps(response['Images'], indent=4, sort_keys=True))

    # print(response['Images'][0]['ImageId'])
    # This is how we access the elements, in the response, by  using the key images, then by index, then by key ImageId to get the amiID


    #Sort the responses images by CreationDate.
    images_sorted = sorted(response['Images'], key=lambda x: x['CreationDate'], reverse=True)

    ami_id = images_sorted[0]['ImageId']

    with open('ami_id.txt', 'w') as f:
        f.write(ami_id)
        f.close()

    # print(ami_id)

get_ami_id()