import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var platform: String = "macOS"
    
    var body: some View {
        VStack {
            Picker("Platform", selection: $platform) {
                Text("macOS").tag("macOS")
                Text("iOS").tag("iOS")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .padding(.top, 20)
            .padding(.bottom, 15)
            
            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Button("Generate Icons") {
                    generateIcons(from: image)
                }
                .padding()
            } else {
                Text("Drop image here or click to select")
                    .frame(width: 250, height: 250)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onTapGesture {
                        openImagePicker()
                    }
            }
            
            if selectedImage == nil {
                Button("Select Image") {
                    openImagePicker()
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [UTType.image.identifier], isTargeted: nil) { providers in
            if let provider = providers.first {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data = data, let nsImage = NSImage(data: data) {
                        DispatchQueue.main.async {
                            self.selectedImage = nsImage
                        }
                    }
                }
            }
            return true
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func openImagePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.urls.first, let image = NSImage(contentsOf: url) {
            selectedImage = image
        }
    }
    
    func generateIcons(from image: NSImage?) {
        guard let image = image else { return }
        let generator = AppIconGenerator()
        generator.generateIcons(for: platform, from: image)
        
        alertMessage = "Icons successfully generated for \(platform)!"
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
