import Foundation

/// Hoeveel foto's de gebruiker wil maken: 1, 2 of 3.
enum ShotConfiguration: Int, CaseIterable, Identifiable {
    case one   = 1
    case two   = 2
    case three = 3

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .one:   return String(localized: "1 foto")
        case .two:   return String(localized: "2 foto's")
        case .three: return String(localized: "3 foto's")
        }
    }

    var description: String {
        switch self {
        case .one:   return String(localized: "shot.description.one")
        case .two:   return String(localized: "shot.description.two")
        case .three: return String(localized: "shot.description.three")
        }
    }
}
