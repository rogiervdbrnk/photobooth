import UIKit

/// Bevat de staat van één photobooth-sessie: configuratie + gemaakte foto's.
@Observable
final class PhotoboothSession {
    let configuration: ShotConfiguration
    let stripText: String
    private(set) var capturedPhotos: [UIImage] = []

    init(configuration: ShotConfiguration, stripText: String) {
        self.configuration = configuration
        self.stripText = stripText
    }

    var totalShots: Int { configuration.rawValue }
    var shotsTaken: Int { capturedPhotos.count }
    var remainingShots: Int { totalShots - shotsTaken }
    var isComplete: Bool { shotsTaken == totalShots }

    func addPhoto(_ image: UIImage) {
        guard capturedPhotos.count < totalShots else { return }
        capturedPhotos.append(image)
    }

    func reset() {
        capturedPhotos.removeAll()
    }
}
