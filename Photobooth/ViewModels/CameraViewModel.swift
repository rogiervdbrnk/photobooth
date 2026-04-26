import SwiftUI

@MainActor
@Observable
final class CameraViewModel {

    // MARK: - State
    var countdownValue: Int?          // nil = geen aftelling actief
    var isCapturing = false
    var currentShotIndex = 0          // 0-gebaseerd
    var showFlash = false
    var error: String?

    // MARK: - Dependencies
    let session: PhotoboothSession
    let cameraService: CameraService

    var onSessionComplete: ((PhotoboothSession) -> Void)?

    init(session: PhotoboothSession, cameraService: CameraService) {
        self.session = session
        self.cameraService = cameraService
    }

    // MARK: - Camera lifecycle

    func onAppear() {
        do {
            try cameraService.configure()
            cameraService.start()
        } catch {
            self.error = error.localizedDescription
            return
        }

    }

    func onDisappear() {
        cameraService.stop()
    }

    // MARK: - Foto-flow

    /// Start de aftelling (3 → 2 → 1) en neemt daarna alle resterende foto's automatisch.
    func startCountdownAndCapture() {
        guard !isCapturing else { return }
        isCapturing = true

        Task {
            while !session.isComplete {
                // Aftelling
                for i in stride(from: 3, through: 1, by: -1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        countdownValue = i
                    }
                    try? await Task.sleep(for: .seconds(1))
                }

                withAnimation {
                    countdownValue = nil
                }

                // Flitseffect
                withAnimation(.easeIn(duration: 0.05)) { showFlash = true }
                try? await Task.sleep(for: .milliseconds(150))
                withAnimation(.easeOut(duration: 0.2)) { showFlash = false }

                // Foto nemen
                do {
                    let image = try await cameraService.capturePhoto()
                    session.addPhoto(image)
                    currentShotIndex = session.shotsTaken

                    if session.isComplete {
                        // Korte pause zodat de flash zichtbaar is
                        try? await Task.sleep(for: .milliseconds(400))
                        isCapturing = false
                        onSessionComplete?(session)
                        return
                    } else {
                        // Pauze tussen shots
                        try? await Task.sleep(for: .seconds(1))
                    }
                } catch {
                    self.error = error.localizedDescription
                    isCapturing = false
                    return
                }
            }
        }
    }
}
