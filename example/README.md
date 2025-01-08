
  # BOXIFY EXAMPLE

  This folder contains the working demo of Boxify (similar to the private Weezify and Rivertunes repositories).  
  If you want to run or contribute to Boxify, **this** is where to start!

  ## Table of Contents
  1. [Overview](#overview)
  2. [Features](#features)
  3. [Project Structure](#project-structure)
  4. [Getting Started](#getting-started)
     - [Prerequisites](#prerequisites)
     - [Firebase Setup](#firebase-setup)
     - [Project Configuration](#project-configuration)
     - [Running the App](#running-the-app)
  5. [Contributing](#contributing)
  6. [Updating Images](#updating-images)
  7. [Upgrading Packages](#upgrading-packages)
  8. [License](#license)
  9. [Contact](#contact)

  ---

  ## Overview
  **Boxify Example** is a fully runnable version of the base Boxify code. It demonstrates how all the pieces fit together and connects to Firebase for authentication, Firestore, etc.

  ---

  ## Features
  - **User Authentication** (Firebase)
  - **Playlist Creation & Management**
  - **Track Management** (add/remove/listen)
  - **Metadata Handling**
  - **Support for Dev/Staging Firebase Environments** (so we don’t touch production data)

  ---

  ## Project Structure
  - `lib/`  
    Contains the configuration for this app's implementation of Boxify. To develop the app, you'll mostly be working in Boxify's `lib/` folder.
  - `assets/`  
    Holds image assets for the UI.
  - `android/` and `ios/`  
    Platform-specific configuration.
  - `firebase_options.dart`  
    manually inserted.  
  - `google-services.json`  
    Placed in `android/app` after you download from Firebase console.  
  - `GoogleService-Info.plist`  
    Placed in `ios/Runner` after you download it.

  ---

  ## Getting Started

  ### Prerequisites
  1. **Flutter SDK** (version specified in `pubspec.yaml`)
  2. **Dart** (bundled with Flutter)
  3. (Optional) **Android Studio** or **VS Code** for local dev.

  ### Firebase Setup
  This example requires a **Firebase project** (development/staging).  

  1. **Contact the maintainer** to be added to the 'boxify-dev' Firebase console.
  2. **Download**:
     - `google-services.json` into `android/app`.
     - `GoogleService-Info.plist` into `ios/Runner`.
     - The auto-generated `firebase_options.dart` into `lib/config/`.
  3. Make sure those files **are not** committed to GitHub if they contain sensitive info. Check `.gitignore`.

  ### Running the App
  1. **Install dependencies**:
     ```bash
     flutter pub get
     ```
  2. **Run**:
     ```bash
     flutter run
     ```
  3. **Select a platform**:
     ```bash
     flutter run -d android
     # or flutter run -d ios
     ```

  ---

  ## Contributing
  Contributions are welcome! Steps:
  1. Fork & create a new branch.
  2. Commit changes with a clear message.
  3. Open a Pull Request into `main` (or whichever branch we use).

  ### Guidelines
  - Follow the existing code style (see `analysis_options.yaml`).
  - Submit small, focused PRs.
  - For major changes, open an issue first to discuss.

  ---

  ## Updating Images
  Add your new images to the `assets/` folder. Then ensure `pubspec.yaml` lists them under `assets:` so Flutter can access them.


  ## License
  <!-- 
    If you have a specific license, link it here, e.g.:
    [MIT License](LICENSE.md)
  -->

  ---

  ## Contact
  - **Maintainer:** Rivers
  - **Email:** rivers@riverscuomo.com
  - **Discord:** https://discord.com/channels/@me/1325992565278900285 
