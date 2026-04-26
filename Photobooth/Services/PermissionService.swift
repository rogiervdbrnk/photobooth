import AVFoundation
import Photos
import Foundation

/// Beheert alle toestemmingsverzoeken voor camera en fotobibliotheek.
final class PermissionService {

    enum PermissionError: LocalizedError {
        case cameraDenied
        case photoLibraryDenied

        var errorDescription: String? {
            switch self {
            case .cameraDenied:
                return String(localized: "permission_error.camera_denied")
            case .photoLibraryDenied:
                return String(localized: "permission_error.photo_library_denied")
            }
        }
    }

    /// Vraagt zowel camera- als fotobibliotheektoegang op.
    func requestAll() async throws {
        try await requestCamera()
        try await requestPhotoLibrary()
    }

    func requestCamera() async throws {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized: return
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted { throw PermissionError.cameraDenied }
        default:
            throw PermissionError.cameraDenied
        }
    }

    func requestPhotoLibrary() async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited: return
        case .notDetermined:
            let result = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            if result != .authorized && result != .limited {
                throw PermissionError.photoLibraryDenied
            }
        default:
            throw PermissionError.photoLibraryDenied
        }
    }
}
