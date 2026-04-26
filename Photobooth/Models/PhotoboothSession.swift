import UIKit

/// Bevat de staat van één photobooth-sessie: configuratie + gemaakte foto's.
@Observable
final class PhotoboothSession {
    let configuration: ShotConfiguration
    var stripText: String
    var stripBackgroundStyle: StripBackgroundStyle
    var photoFilter: PhotoFilterOption
    var photoFrameStyle: PhotoFrameStyle
    private(set) var capturedPhotos: [UIImage] = []

    init(
        configuration: ShotConfiguration,
        stripText: String,
        stripBackgroundStyle: StripBackgroundStyle = .classicWhite,
        photoFilter: PhotoFilterOption = .original,
        photoFrameStyle: PhotoFrameStyle = .none
    ) {
        self.configuration = configuration
        self.stripText = stripText
        self.stripBackgroundStyle = stripBackgroundStyle
        self.photoFilter = photoFilter
        self.photoFrameStyle = photoFrameStyle
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
