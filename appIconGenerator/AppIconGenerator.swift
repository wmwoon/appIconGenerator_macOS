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
        
        for (size, scale, mode) in sizes {
            let actualSize = scale == "2x" ? size * 2 : (scale == "3x" ? size * 3 : size)
            let modeSuffix = mode != nil ? "-\(mode!)" : ""
            let filename = "\(Int(size))@\(scale)\(modeSuffix).png"
            
            // Resize the image and save it
            if let resizedImage = resizeImage(image, to: CGSize(width: actualSize, height: actualSize)) {
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

    
    func resizeImage(_ image: NSImage, to size: CGSize) -> NSImage? {
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: size))
        newImage.unlockFocus()
        return newImage
    }
    
    func saveImage(_ image: NSImage, as filename: String, to folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent(filename)
        print("Saving to file: \(fileURL.path)") // Check where it's attempting to save

        if let imageData = image.tiffRepresentation,
           let bitmapRep = NSBitmapImageRep(data: imageData),
           let pngData = bitmapRep.representation(using: .png, properties: [:]) {
            do {
                try pngData.write(to: fileURL)
                print("File saved successfully!")
            } catch {
                print("Failed to save file: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContentsJSON(_ json: [String: Any], to folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent("Contents.json")
        print("Saving Contents.json to file: \(fileURL.path)") // Check where it's attempting to save

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("Contents.json saved successfully!")
        } catch {
            print("Failed to save Contents.json: \(error.localizedDescription)")
        }
    }
}
