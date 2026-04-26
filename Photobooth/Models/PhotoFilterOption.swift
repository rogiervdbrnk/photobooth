import Foundation

/// Beschrijft welk fotofilter op de vastgelegde foto's toegepast wordt.
enum PhotoFilterOption: String, CaseIterable, Identifiable, Codable {
    case original
    case mono
    case noir
    case sepia
    case chrome
    case fade

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .original:
            return String(localized: "photo_filter.original")
        case .mono:
            return String(localized: "photo_filter.mono")
        case .noir:
            return String(localized: "photo_filter.noir")
        case .sepia:
            return String(localized: "photo_filter.sepia")
        case .chrome:
            return String(localized: "photo_filter.chrome")
        case .fade:
            return String(localized: "photo_filter.fade")
        }
    }
}