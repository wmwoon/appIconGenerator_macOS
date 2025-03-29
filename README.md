# AppIcon Generator for macOS
![Screenshot 2025-03-29 at 14 59 05](https://github.com/user-attachments/assets/f0431602-9cc5-4360-8e17-fe4868ac8e98)
This macOS app automates the generation of app icons in multiple sizes for use in Xcode. Simply drag and drop a source image, and the app will generate the required icon sizes while preserving transparency.

## Features
- Supports macOS app icon sizes.
- Automatically generates `Contents.json` for Xcode.
- Preserves transparency.
- Simple drag-and-drop UI.

## Supported Icon Sizes
The app generates the following sizes for macOS:
- 16x16 (1x, 2x)
- 32x32 (1x, 2x)
- 128x128 (1x, 2x)
- 256x256 (1x, 2x)
- 512x512 (1x, 2x)

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

## License
This project is open-source and available under the MIT License.

