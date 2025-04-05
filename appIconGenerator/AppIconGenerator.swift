import Cocoa

class AppIconGenerator {
    func generateIcons(for platform: String, from image: NSImage) {
        // Get the Desktop directory path
        let fileManager = FileManager.default
        let desktopPath = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let folderURL = desktopPath.appendingPathComponent("AppIcon.appiconset")
        
        // Create the folder if it doesn't exist
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            print("Directory created at: \(folderURL.path)")
        } catch {
            print("Failed to create directory: \(error.localizedDescription)")
        }
        
        // Proceed with generating icons for the selected platform (macOS or iOS)
        let sizes = (platform == "macOS") ? IconSizes.macSizes.map { ($0.0, $0.1, nil) } : IconSizes.iosSizes
        var imagesArray: [[String: Any]] = []
        
        // IMPORTANT: Make sure the source image has its size explicitly set
        let sourceImage = NSImage(data: image.tiffRepresentation!)!
        
        for (size, scale, mode) in sizes {
            // Parse scale factor from string
            let scaleFactor: CGFloat
            if scale == "1x" {
                scaleFactor = 1.0
            } else if scale == "2x" {
                scaleFactor = 2.0
            } else if scale == "3x" {
                scaleFactor = 3.0
            } else {
                scaleFactor = 1.0
            }
            
            // Calculate pixel dimensions
            let pixelSize = size * scaleFactor
            print("Generating \(size)pt @\(scale) icon → \(pixelSize)×\(pixelSize) pixels")
            
            let modeSuffix = mode != nil ? "-\(mode!)" : ""
            let filename = "\(Int(size))@\(scale)\(modeSuffix).png"
            
            // Create a new image representation at the exact size needed
            if let resizedImage = createIconImage(from: sourceImage, size: CGSize(width: pixelSize, height: pixelSize)) {
                saveImage(resizedImage, as: filename, to: folderURL)
            }
            
            var imageEntry: [String: Any] = [
                "filename": filename,
                "idiom": platform == "macOS" ? "mac" : "iphone",
                "scale": scale,
                "size": "\(Int(size))x\(Int(size))"
            ]
            
            if let mode = mode {
                imageEntry["appearances"] = [["appearance": mode == "white" ? "contrast" : "luminosity", "value": mode]]
            }
            
            imagesArray.append(imageEntry)
        }
        
        // Save the Contents.json file
        let jsonOutput: [String: Any] = [
            "images": imagesArray,
            "info": ["author": "xcode", "version": 1]
        ]
        saveContentsJSON(jsonOutput, to: folderURL)
    }
    
    // Completely revised image resizing function that avoids Retina display complications
    func createIconImage(from sourceImage: NSImage, size: CGSize) -> NSImage? {
        // Create a bitmap representation at the exact pixel dimensions we need
        let representation = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )
        
        representation?.size = size
        
        // Draw the image into the new representation
        NSGraphicsContext.saveGraphicsState()
        if let context = NSGraphicsContext(bitmapImageRep: representation!) {
            NSGraphicsContext.current = context
            let drawRect = NSRect(origin: .zero, size: size)
            sourceImage.draw(in: drawRect, from: NSRect(origin: .zero, size: sourceImage.size), operation: .copy, fraction: 1.0)
        }
        NSGraphicsContext.restoreGraphicsState()
        
        // Create a new NSImage with the exact bitmap representation
        let newImage = NSImage(size: size)
        newImage.addRepresentation(representation!)
        
        return newImage
    }
    
    func saveImage(_ image: NSImage, as filename: String, to folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent(filename)
        print("Saving to file: \(fileURL.path)")
        
        if let imageData = image.tiffRepresentation,
           let bitmapRep = NSBitmapImageRep(data: imageData) {
            // Check the actual dimensions of the bitmap we're about to save
            print("Bitmap dimensions: \(bitmapRep.pixelsWide)×\(bitmapRep.pixelsHigh)")
            
            if let pngData = bitmapRep.representation(using: .png, properties: [:]) {
                do {
                    try pngData.write(to: fileURL)
                    print("File saved successfully!")
                } catch {
                    print("Failed to save file: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveContentsJSON(_ json: [String: Any], to folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent("Contents.json")
        print("Saving Contents.json to file: \(fileURL.path)")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("Contents.json saved successfully!")
        } catch {
            print("Failed to save Contents.json: \(error.localizedDescription)")
        }
    }
}
