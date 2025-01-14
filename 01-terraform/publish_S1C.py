#!/usr/bin/python

import getopt
import requests
import sys
import os
import json
import time

# Extracting environment variables
checkpoint_server = os.environ.get('CHECKPOINT_SERVER')
checkpoint_cloud_mgmt_id = os.environ.get('CHECKPOINT_CLOUD_MGMT_ID')

# Open the JSON file containing session ID
with open('sid.json', 'r') as json_file:
    data = json.load(json_file)

# Extract session ID
sid = data['sid']

# Set login info
url = f"https://{checkpoint_server}/{checkpoint_cloud_mgmt_id}/web_api/publish"
payload = "{}"
headers = {
    'Content-Type': "application/json",
    'Cache-Control': "no-cache",
    'X-chkp-sid': sid,  # No need for concatenation
}

# Disable SSL Certificate Checking
requests.packages.urllib3.disable_warnings()

# Make the initial POST request
response = requests.request("POST", url, data=payload, headers=headers, verify=False)

# Extract Task ID from the response
api_json = json.loads(response.text)
print("Task ID is " + api_json['task-id'])

# Sleep for 2 seconds before checking the status of the Task
time.sleep(2)

# Check the status of the task
progress_percentage = 0
while progress_percentage < 100:
    # Make a POST request to get task status
    url = f"https://{checkpoint_server}/{checkpoint_cloud_mgmt_id}/web_api/show-task"
    payload = {
        "task-id": api_json['task-id']  # Use a dictionary directly
    }
    response = requests.request("POST", url, json=payload, headers=headers, verify=False)
    task_status = json.loads(response.text)
    sys.stdout.write("\rProgress " + str(task_status['tasks'][0]['progress-percentage']) + "%")
    sys.stdout.flush()
    progress_percentage = task_status['tasks'][0]['progress-percentage']
    time.sleep(1)

print()  # Move to next line after loop ends