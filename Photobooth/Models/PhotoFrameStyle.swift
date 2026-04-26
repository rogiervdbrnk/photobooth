import Foundation

/// Beschrijft welke decoratieve frame- of feeststijl rond de foto's gebruikt wordt.
enum PhotoFrameStyle: String, CaseIterable, Identifiable, Codable {
    case none
    case balloons
    case confetti
    case stars
    case disco

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none:
            return String(localized: "photo_frame.none")
        case .balloons:
            return String(localized: "photo_frame.balloons")
        case .confetti:
            return String(localized: "photo_frame.confetti")
        case .stars:
            return String(localized: "photo_frame.stars")
        case .disco:
            return String(localized: "photo_frame.disco")
        }
    }
}