# Examplify scripts

Mostly just imports and runs boxify_scripts.

## Installation

### Create the venv (use the name of the computer, such as G for desktop or 9 for laptop)

Make sure you have an approved version of Python (probably not the latest version)
Currently we're on 3.11.5. I do it like this.

`"C:\Users\aethe\AppData\Local\Programs\Python\Python311\python" -m venv .G`
`"C:\Users\Rivers Cuomo\AppData\Local\Programs\Python\Python311\python.exe" -m venv .9`

### Install the packages in requirements.txt into the venv\Lib\site-packages directory

Do this first:
Navigate to the directory with the requirements.txt file (boxify\example\scripts) and run:

`pip install -r requirements.txt`

### Firebase Service Account

You will need to create and download the service account json file for the boxify-dev firebase project.

<https://console.firebase.google.com/u/0/project/boxify-dev-96c50/settings/serviceaccounts/adminsdk>

Save the file as `boxify-dev-service-account.json` whereever you like but make sure not to commit this file to the repository. Add it to the `.gitignore`file if it sits inside this repository.

### Environment Variables

Put a .env file in the example/ directory with the following contents:

`FIREBASE_KEY_PATH=` (path to the service account json file you just created and downloaded, no quotes)

## Running scripts against the example Firestore project

Clone the boxify-scripts repo and follow the instructions in the README.md file.
