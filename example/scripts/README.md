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

## Running scripts against the example Firestore project

Clone the boxify-scripts repo and follow the instructions in the README.md file.
