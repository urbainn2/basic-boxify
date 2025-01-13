# Examplify scripts

Mostly just imports and runs boxify_scripts.

## Installation

### Create the venv (use the name of the computer, such as G for desktop or 9 for laptop)

Make sure you have an approved version of Python (probably not the latest version)
Currently we're on 3.11.5

`"C:\Users\aethe\AppData\Local\Programs\Python\Python311\python" -m venv .G`
`"C:\Users\Rivers Cuomo\AppData\Local\Programs\Python\Python311\python.exe" -m venv .9`

Make sure you open a new terminal to activate the venv. Otherwise you'll be installing packages into the global python environment.
!!! activate with .9\Scripts\activate .G\Scripts\activate !!!

### Install the packages in requirements.txt into the venv\Lib\site-packages directory

Do this first:
pip install -r requirements.txt

You'll notice the local packages are not installed. That's because they are not in the requirements.txt file. You need to install them separately.

`cd gspreader`
`pip install -e .`

pip install -e ai/.
pip install -e anki/.
pip install -e catalog/.
pip install -e crawlers/.
pip install -e demos/.
pip install -e kyoko/.
pip install -e lyricprocessor/.
pip install -e new_albums/.
pip install -e rhymes/.
pip install -e social/.
pip install -e spotkin/.
pip install -e gspreader/.
pip install -e rivertils/.

# Running scripts against the example Firestore project

You will need to create and download the service account json file from the Firebase console and place it in the `lib/config/` directory.

<https://console.firebase.google.com/u/0/project/boxify-dev-96c50/settings/serviceaccounts/adminsdk>

Make sure not to commit this file to the repository. Add it to the `.gitignore` file.
