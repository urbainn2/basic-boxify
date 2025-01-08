# Common

Python Scripts and functions that are common to all Boxify apps, such as Weezify and RiverTunes.

20220-08-30
Fixed create_database_rows_from_files() to set the uuid in the database rows of tracks table. (It was still using localpath and therefore succeeding functions weren't finding the tracks.)


# Working with Python Scripts
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