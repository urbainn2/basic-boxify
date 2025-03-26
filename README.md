# BASIC-BOXIFY
  This folder contains the working demo of the Basic App version of [Rivers Cuomo](https://github.com/riverscuomo)'s [Boxify](https://github.com/riverscuomo/boxify).\
  This repository is mainly used as a testing ground to see how changes may impact the Basic App.

## Overview

Boxify serves as the foundation for our family of music streaming apps. The core functionality is centralized here, making it easier to maintain consistency across all applications.

## Structure

- The main functionality is located in the `lib/` directory
- When developing for specific apps (like Weezify), you'll primarily work with code in this directory
- Any changes made here will affect all dependent applications

## Getting Started

For detailed setup and usage instructions, please refer to:

[`Getting Started Wiki`](https://github.com/riverscuomo/boxify/wiki)

## Contributing

If you're interested in contributing or running Boxify locally:

1. Check out the documentation in [`examplify/README.md`](examplify/README.md)
2. Follow the setup instructions provided there
3. Make your changes in the appropriate `boxify/lib/` subdirectory

## Python scripts for working with firebase_admin and the Firestore database

If you want to work with the Firestore database directly, there is another repo called `boxify-scripts` that contains the scripts.
