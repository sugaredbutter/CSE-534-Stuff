import os
import re
#import paramiko
import subprocess
import shutil
from glob import glob

def update_config(policyType, value):
        config_file_path = os.path.expanduser("~/AStream/dist/client/config_dash.py")
        with open(config_file_path, 'r') as config_file:
                config_data = config_file.read()
        if policyType == 'basic':
                currentValue = re.search(r"MAX_BUFFER_SIZE = (\d+)", config_data).group(1)
                print('basic',currentValue)
                config_data = config_data.replace(f"MAX_BUFFER_SIZE = {currentValue}", f"MAX_BUFFER_SIZE = {value}")
        if policyType == 'netflix':
                currentValue = re.search(r"NETFLIX_BUFFER_SIZE = (\d+)", config_data).group(1)
                print('netflix',currentValue)
                config_data = config_data.replace(f"NETFLIX_BUFFER_SIZE = {currentValue}", f"NETFLIX_BUFFER_SIZE = {value}")
        with open(config_file_path, 'w') as config_file:
                config_file.write(config_data)
        print("yeah")


policy = ['basic', 'netflix']
bufferSize = [10, 50, 100]
pattern = ['constant', 'valley', 'hill']
time = [180, 300]
dash_path = os.path.expanduser('~/AStream/dist/client/dash_client.py')
for policyType in policy:
        for size in bufferSize:         
                update_config(policyType, size)
                for rate in pattern:
                        for timeout in time:
                                if rate == 'constant':
                                        subprocess.Popen(['bash', 'constant.sh'])
                                if rate == 'valley':
                                        if timeout == 180:
                                                subprocess.Popen(['bash', 'valley3.sh'])
                                        else:
                                                subprocess.Popen(['bash',' valley5.sh'])
                                if rate == 'hill':
                                        if timeout == 180:
                                                subprocess.Popen(['bash', 'hill3.sh'])
                                        else:
                                                subprocess.Popen(['bash', 'hill5.sh'])
                                command = [
                                    'python3', 
                                    dash_path, 
                                    '-m', 'http://juliet/media/BigBuckBunny/4sec/BigBuckBunny_4s.mpd', 
                                    '-p', policyType,
                                    '-d'
                                ]
                                try:
                                    subprocess.run(command, timeout=timeout)
                                except subprocess.TimeoutExpired:
                                    print(policyType, size, rate, timeout, "finished")
                                Astream = os.path.expanduser("~/ASTREAM_LOGS/")
                                newThing = "~/EXERCISE2_LOGS/" + policyType + "_" + str(size) + "_" + rate + "_" + str(timeout) + ".csv"
                                destination = os.path.expanduser(newThing)
                                files = glob(os.path.join(Astream, "DASH_BUFFER_LOG_*"))
                                if files:
                                        recent = max(files, key=os.path.getmtime)
                                        shutil.copy2(recent, destination)
