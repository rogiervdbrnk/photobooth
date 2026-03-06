import Foundation
import SwiftUI
import UIKit

@Observable
final class ShotSelectionViewModel {
    var selectedConfiguration: ShotConfiguration = .three
    @ObservationIgnored @AppStorage("stripText") var stripText: String = ""
    var showPermissionAlert = false
    var permissionError: String?

    private let permissionService = PermissionService()

    /// Wordt aangeroepen door AppCoordinator zodra toestemming verleend is.
    var onConfirm: ((ShotConfiguration, String) -> Void)?

    func confirm() {
        Task { @MainActor in
            do {
                try await permissionService.requestAll()
                onConfirm?(selectedConfiguration, stripText)
            } catch {
                permissionError = error.localizedDescription
                showPermissionAlert = true
            }
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
