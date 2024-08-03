import os

directory = 'Backend/'
file_to_ignore = 'wellcarebot-71cca-firebase-adminsdk-v1v74-7337868583.json'

for root, dirs, files in os.walk(directory):
    for file in files:
        if file != file_to_ignore:
            file_path = os.path.join(root, file)
            # Process the file
            print(f"Processing {file_path}")
