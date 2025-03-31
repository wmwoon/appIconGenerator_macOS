# AppIcon Generator for macOS
![Screenshot 2025-03-29 at 14 59 05](https://github.com/user-attachments/assets/f0431602-9cc5-4360-8e17-fe4868ac8e98)
This macOS app automates the generation of app icons in multiple sizes for use in Xcode. Simply drag and drop a source image, and the app will generate the required icon sizes while preserving transparency. I made this while I was trying to generate diferent sizes of app icons for an app. Foudn some online ones but don't really like to upload my stuff and then download it back. And since I'm on Xcode, why not just come up with something that does similar but less the Internet.

## Features

- Supports generating app icons for both **macOS** and **iOS** platforms.
- Automatically resizes the source image into multiple required sizes for macOS and iOS.
- Supports **light mode**, **dark mode**, and **tinted** icons for iOS.
- Generates a `Contents.json` file required for use in Xcode asset catalogs.


### macOS
The following sizes are generated for macOS:

- **16x16** (1x, 2x)
- **32x32** (1x, 2x)
- **128x128** (1x, 2x)
- **256x256** (1x, 2x)
- **512x512** (1x, 2x)

### iOS
The following sizes are generated for iOS, supporting **light**, **dark**, and **tinted** modes with 1x, 2x, and 3x scale factors:

- **20x20** (1x, 2x, 3x) for notification icons
- **29x29** (1x, 2x, 3x) for settings icons
- **40x40** (1x, 2x, 3x) for spotlight icons
- **60x60** (2x, 3x) for app icons
- **76x76** (1x, 2x) for iPad icons
- **83.5x83.5** (2x) for iPad Pro icons
- **1024x1024** (1x) for the App Store icon

## Installation

1. Clone or download this repository.
2. Open the project in **Xcode**.
3. Build and run the app on macOS.

## How to Use
1. **Launch the App**: Open the AppIcon Generator.
2. **Drag and Drop**: Drop your source image into the app.
3. **Generate Icons**: Click the "Generate App Icons" button.
4. **Find Output**: Icons are saved in `AppIcon.appiconset` on your desktop.

## Output Structure
The app creates a folder with:
- Resized icon images.
- A `Contents.json` file for Xcode asset catalogs.

## Requirements
- macOS 12.0 or later
- Xcode (for integrating generated icons into projects)

## About

This app was created to simplify the process of generating multiple sizes and formats for macOS and iOS app icons. It was developed with the help of AI assistants.

## License
This project is open-source and available under the MIT License.

### Completed app can be download here -> https://github.com/wmwoon/appIconGenerator_macOS/discussions/1


