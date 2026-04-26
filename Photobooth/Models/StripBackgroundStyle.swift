import Foundation

/// Beschrijft de visuele achtergrondstijl van de uiteindelijke fotostrip.
enum StripBackgroundStyle: String, CaseIterable, Identifiable, Codable {
    case classicWhite
    case pinkParty
    case goldConfetti
    case purpleStars
    case rainbowCake
    case orange

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classicWhite:
            return String(localized: "strip_background.classicWhite")
        case .pinkParty:
            return String(localized: "strip_background.pinkParty")
        case .goldConfetti:
            return String(localized: "strip_background.goldConfetti")
        case .purpleStars:
            return String(localized: "strip_background.purpleStars")
        case .rainbowCake:
            return String(localized: "strip_background.rainbowCake")
        case .orange:
            return String(localized: "strip_background.orange")
        }
    }
}
