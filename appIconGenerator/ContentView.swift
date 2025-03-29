import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var droppedImage: NSImage? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if let image = droppedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Button("Generate App Icons") {
                    generateAppIcons(from: image)
                }
                .padding()
            } else {
                Text("Drop an image here")
                    .frame(width: 200, height: 200)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [UTType.image.identifier], isTargeted: nil) { providers in
            if let provider = providers.first {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data = data, let nsImage = NSImage(data: data) {
                        DispatchQueue.main.async {
                            self.droppedImage = nsImage
                        }
                    }
                }
            }
            return true
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func resizeImage(_ image: NSImage, to newSize: NSSize) -> NSImage? {
        let img = NSImage(size: newSize)
        img.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        image.draw(in: NSRect(origin: .zero, size: newSize),
                   from: NSRect(origin: .zero, size: image.size),
                   operation: .sourceOver,
                   fraction: 1.0)
        img.unlockFocus()
        return img
    }
    
    func generateAppIcons(from image: NSImage) {
        let sizes: [(CGFloat, String)] = [
            (16, "1x"), (16, "2x"),
            (32, "1x"), (32, "2x"),
            (128, "1x"), (128, "2x"),
            (256, "1x"), (256, "2x"),
            (512, "1x"), (512, "2x")
        ]
        let fileManager = FileManager.default
        let desktopPath = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let folderURL = desktopPath.appendingPathComponent("AppIcon.appiconset")
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            
            var imagesArray: [[String: Any]] = []
            
            for (size, scale) in sizes {
                let actualSize = scale == "2x" ? size : size / 2
                let newSize = NSSize(width: actualSize, height: actualSize)
                if let resizedImage = resizeImage(image, to: newSize) {
                    let imageData = resizedImage.tiffRepresentation
                    let filename = "\(Int(size))@\(scale).png"
                    let outputPath = folderURL.appendingPathComponent(filename)
                    try imageData?.write(to: outputPath)
                    
                    imagesArray.append([
                        "filename": filename,
                        "idiom": "mac",
                        "scale": scale,
                        "size": "\(Int(size))x\(Int(size))"
                    ])
                }
            }
            
            let contentsJson: [String: Any] = [
                "images": imagesArray,
                "info": ["author": "xcode", "version": 1]
            ]
            
            let jsonData = try JSONSerialization.data(withJSONObject: contentsJson, options: .prettyPrinted)
            let jsonPath = folderURL.appendingPathComponent("Contents.json")
            try jsonData.write(to: jsonPath)
            
            DispatchQueue.main.async {
                alertMessage = "App icons have been successfully generated at \(folderURL.path)"
                showAlert = true
            }
            
        } catch {
            DispatchQueue.main.async {
                alertMessage = "Error saving images: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
