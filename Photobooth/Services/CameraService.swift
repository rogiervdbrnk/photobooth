import AVFoundation
import Foundation
import UIKit

/// Beheert de AVFoundation capture session en het nemen van foto's via de frontcamera.
@MainActor
@Observable
final class CameraService: NSObject {

    // MARK: - Public state
    var captureSession = AVCaptureSession()
    var error: Error?

    // MARK: - Private
    private let photoOutput = AVCapturePhotoOutput()
    private var continuation: CheckedContinuation<UIImage, Error>?

    // MARK: - Setup

    /// Configureert de sessie met de frontcamera.
    func configure() throws {
        captureSession.beginConfiguration()

        // Verwijder bestaande inputs/outputs zodat configure() veilig herhaald kan worden
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession.outputs.forEach { captureSession.removeOutput($0) }

        captureSession.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera, for: .video, position: .front
        ) else {
            captureSession.commitConfiguration()
            throw CameraError.deviceNotFound
        }

        let input = try AVCaptureDeviceInput(device: device)
        guard captureSession.canAddInput(input) else {
            captureSession.commitConfiguration()
            throw CameraError.cannotAddInput
        }
        captureSession.addInput(input)

        guard captureSession.canAddOutput(photoOutput) else {
            captureSession.commitConfiguration()
            throw CameraError.cannotAddOutput
        }
        captureSession.addOutput(photoOutput)

        // Spiegel de preview voor de frontcamera
        if let connection = photoOutput.connection(with: .video) {
            connection.isVideoMirrored = true
        }

        captureSession.commitConfiguration()
    }

    func start() {
        guard !captureSession.isRunning else { return }
        let session = captureSession
        Task.detached(priority: .userInitiated) {
            session.startRunning()
        }
    }

    func stop() {
        guard captureSession.isRunning else { return }
        let session = captureSession
        Task.detached(priority: .userInitiated) {
            session.stopRunning()
        }
    }

    // MARK: - Capture

    /// Neemt een foto en geeft een UIImage terug via async/await.
    func capturePhoto() async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .off
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    // MARK: - Errors

    enum CameraError: LocalizedError {
        case deviceNotFound
        case cannotAddInput
        case cannotAddOutput
        case captureFailed

        var errorDescription: String? {
            switch self {
            case .deviceNotFound:
                return String(localized: "camera_error.device_not_found")
            case .cannotAddInput:
                return String(localized: "camera_error.cannot_add_input")
            case .cannotAddOutput:
                return String(localized: "camera_error.cannot_add_output")
            case .captureFailed:
                return String(localized: "camera_error.capture_failed")
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraService: AVCapturePhotoCaptureDelegate {

    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let result: Result<UIImage, Error>

        if let error {
            result = .failure(error)
        } else if
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        {
            result = .success(image)
        } else {
            result = .failure(CameraError.captureFailed)
        }

        Task { @MainActor in
            switch result {
            case .success(let image):
                self.continuation?.resume(returning: image)
            case .failure(let err):
                self.continuation?.resume(throwing: err)
            }
            self.continuation = nil
        }
    }
}
