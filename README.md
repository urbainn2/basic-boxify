# BOXIFY
This is the base app from which Weezify is built.

## Updating Images
- To update images, just add the assets to the assets folder. The programmatic parameters aren't really accessed.

## installation
### set environment variable for the following:
DROPBOX_HOME=your dropbox home directory where this project is stored
APPS_FLUTTER_HOME=your directore where this project is stored

### Create the venv with a specific version of python:

"C:\Users\Rivers Cuomo\AppData\Local\Programs\Python\Python310\python.exe" -m venv .venv

- You can use the following code to generate a requirements.txt file:
- pip install pipreqs
- pipreqs --encoding=utf8 /path/to/project
- pip install -r requirements.txt

## Upgrading venv python version
python -m venv --upgrade .venv    OR env_dir    

## Upgrading Packages
flutter pub upgrade --major-versions
flutter packages upgrade
