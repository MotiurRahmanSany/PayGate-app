#!/bin/bash

clear
# Build the Flutter app for Android
echo "Cleaning the project..."
flutter clean
flutter pub get
clear
echo "Starting the build process... in release mode"
flutter build apk --release
echo "Build completed successfully."