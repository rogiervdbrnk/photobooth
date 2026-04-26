import Foundation
import Photos
import UIKit

/// Slaat een UIImage op in de Camera Rol van het apparaat.
final class PhotoLibraryService {

    enum SaveError: LocalizedError {
        case saveFailed(Error)

        var errorDescription: String? {
            if case .saveFailed(let e) = self {
                return String(localized: "photo_library_error.save_failed") + ": \(e.localizedDescription)"
            }
            return nil
        }
    }

    func save(_ image: UIImage) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if let error {
                    continuation.resume(throwing: SaveError.saveFailed(error))
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
