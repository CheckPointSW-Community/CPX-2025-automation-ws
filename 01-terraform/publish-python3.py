#!/usr/bin/python3

import os
import requests
import json
import time
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description='Process sid.json file.')
    parser.add_argument('-s', '--sid', required=True, help='Path to the sid.json file')
    args = parser.parse_args()

    sid_file = args.sid
    print(f'Using sid file: {sid_file}')

    # Get the server address from the environment variable CHECKPOINT_SERVER
    checkpoint_server = os.getenv('CHECKPOINT_SERVER', '10.2.0.84')  # Default to '10.2.0.84' if env variable is not set

    # Read the session ID from the sid.json file
    with open(sid_file, 'r') as json_file:
        data = json.load(json_file)

    sid = data['sid']

    # Set login info
    url = f"https://{checkpoint_server}/web_api/publish"
    payload = "{}"
    headers = {
        'Content-Type': "application/json",
        'Cache-Control': "no-cache",
        'X-chkp-sid': sid,
    }

    # SSL Certificate Checking is disabled!!!
    requests.packages.urllib3.disable_warnings()

    # Send the POST request to publish
    response = requests.post(url, data=payload, headers=headers, verify=False)

    # Grab the Task id from the response
    api_json = response.json()
    print(f"Task ID is {api_json['task-id']}")

    # Sleep for 2 seconds before checking the status of the Task
    time.sleep(2)

    # Check the status of the task
    progress_percentage = 0
    while progress_percentage < 100:
        url = f"https://{checkpoint_server}/web_api/show-task"
        payload = json.dumps({"task-id": api_json['task-id']})
        response = requests.post(url, data=payload, headers=headers, verify=False)
        
        task_status = response.json()
        sys.stdout.write(f"\rProgress {task_status['tasks'][0]['progress-percentage']}%")
        sys.stdout.flush()
        
        progress_percentage = task_status['tasks'][0]['progress-percentage']
        time.sleep(1)

    print("")

if __name__ == "__main__":
    main()