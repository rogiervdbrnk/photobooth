import SwiftUI
import UIKit

/// Rendert een SwiftUI-templateview naar een UIImage op @3x resolutie.
final class TemplateRenderer {

    /// Rendert de gegeven SwiftUI-view naar een UIImage.
    /// - Parameters:
    ///   - view: De te renderen SwiftUI-view
    ///   - size: De gewenste uitvoergrootte in punten
    /// - Returns: UIImage op @3x schaal (hoge resolutie voor delen/opslaan)
    @MainActor
    func render<V: View>(_ view: V, size: CGSize) -> UIImage {
        let renderer = ImageRenderer(
            content: view
                .frame(width: size.width, height: size.height)
        )
        renderer.scale = 3.0
        renderer.isOpaque = true
        return renderer.uiImage ?? UIImage()
    }
}
