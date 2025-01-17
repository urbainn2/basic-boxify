# BOXIFY

A shared core library powering multiple music streaming applications (Weezify, RiverTunes, and more?).

## Overview

Boxify serves as the foundation for our family of music streaming apps. The core functionality is centralized here, making it easier to maintain consistency across all applications.

## Structure

- The main functionality is located in the `lib/` directory
- When developing for specific apps (like Weezify), you'll primarily work with code in this directory
- Any changes made here will affect all dependent applications

## Getting Started

For detailed setup and usage instructions, please refer to:

- Primary documentation: [`example/`](example) directory
- Development guide: [`example/README.md`](example/README.md)

## Python scripts for working with firebase_admin and the Firestore database

- `firebase_admin.py`  
All the code in this repo is for the front end Flutter app. If you want to work with the Firestore database directly, you'll need to use the `firebase_admin` Python library.
There is another repo called `boxify-scripts` that contains some core scripts for working with the Firestore database.
You'll need to create a service account key from the Firebase console and save it ....
Rivers also has many scripts in his private 'Weezify' repo.

## Contributing

If you're interested in contributing or running Boxify locally:

1. Check out the documentation in [`example/README.md`](example/README.md)
2. Follow the setup instructions provided there
3. Make your changes in the appropriate `lib/` subdirectory

git submodule add --name boxify-scripts <https://github.com/riverscuomo/boxify> weezify/scripts/boxify_scripts
