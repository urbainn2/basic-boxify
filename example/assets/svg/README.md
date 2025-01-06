## Overview

This directory contains SVG files for use within the app.

### Icons

Some of the SVGs in this directory are used as custom menu item icons.
See [CustomIcons.dart].

### Icon Creation

We have [fontify](https://pub.dev/packages/fontify) configured for the app in the [pubspec.yaml] file,
but it's not working as expected at this time, therefore conversion to a custom icon is a manual process at the moment.

**Fontify Issues**

* It generates an `.otf` version fonts file for the icons, which it appears may not work with certain versions of Flutter.  It renders a bogus character when running in our app.

In the meanwhile, we have a manual process for adding/updating the icons.  

### Manual Process

1. Upload all `.svg`s to [fluttericon](https://www.fluttericon.com/).  This does not retain or store them on the server side.
2. Select the icons you uploaded and click `Download (N)`. (In the upper right corner, where N is the number of icons you uploaded)
3. Unzip the `.zip`, and move the `fonts/MyFlutterApp.ttf` to `<projectDir>/main_app/fonts/custom_icons_font.ttf`.  (The destination name must be custom_icons_font.ttf in that directory).
4. Open the unzipped `my_flutter_app_icons.dart` file and copy the lines that start with `static const IconData...` into the project file `Icon/lib/custom_icons.dart` file.  Note that these lines should replace existing entries, however you need to copy over the existing entries for fontFamily and fontPackage.

This process is messy and clearly not ideal. Once we have fontify in place, and working with otf fonts, we'll be able to regenerate font Icons with no manual steps at all.  We'll just run fontify from the command line at the base of our project.