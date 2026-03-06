import SwiftUI

/// Beheert welk scherm er getoond wordt.
@Observable
final class AppCoordinator {

    enum Screen: Equatable {
        case shotSelection
        case camera(PhotoboothSession)
        case result(PhotoboothSession)

        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.shotSelection, .shotSelection): return true
            case (.camera, .camera):               return true
            case (.result, .result):               return true
            default:                               return false
            }
        }
    }

    var currentScreen: Screen = .shotSelection

    func goToCamera(with config: ShotConfiguration, stripText: String) {
        let session = PhotoboothSession(configuration: config, stripText: stripText)
        withAnimation(.easeInOut(duration: 0.35)) {
            currentScreen = .camera(session)
        }
    }

    func goToResult(with session: PhotoboothSession) {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentScreen = .result(session)
        }
    }

    func restart() {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentScreen = .shotSelection
        }
    }
}
