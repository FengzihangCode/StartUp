import SwiftUI
import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct BlurredWallpaperView: View {
    @State private var blurredImage: NSImage? = nil
    let blurRadius: Double = 30
    
    func getWallpaper() -> NSImage? {
        guard let screen = NSScreen.main else { return nil }
        if let url = NSWorkspace.shared.desktopImageURL(for: screen),
           let image = NSImage(contentsOf: url) {
            return image
        }
        return nil
    }
    
    func blur(image: NSImage, radius: Double) -> NSImage? {
        guard let tiffData = image.tiffRepresentation,
              let ciImage = CIImage(data: tiffData) else { return nil }
        let context = CIContext()
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = Float(radius)
        guard let output = filter.outputImage else { return nil }
        if let cgimg = context.createCGImage(output, from: ciImage.extent) {
            return NSImage(cgImage: cgimg, size: image.size)
        }
        return nil
    }
    
    var body: some View {
        GeometryReader { geo in
            if let img = blurredImage {
                Image(nsImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            } else {
                Color.black.opacity(0.5)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            if let wallpaper = getWallpaper() {
                blurredImage = blur(image: wallpaper, radius: blurRadius)
            }
        }
    }
}
