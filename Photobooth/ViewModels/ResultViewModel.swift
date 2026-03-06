import SwiftUI

@Observable
final class ResultViewModel {

    let session: PhotoboothSession
    var renderedImage: UIImage?
    var isSaving = false
    var saveError: String?
    var showShareSheet = false
    var autoSaveCompleted = false
    var shareURL: URL?
    var isPreparingShare = false

    var onDiscard: (() -> Void)?

    private let photoLibraryService = PhotoLibraryService()
    private let templateRenderer = TemplateRenderer()

    init(session: PhotoboothSession) {
        self.session = session
    }

    @MainActor
    func onAppear() {
        renderTemplate()
    }

    @MainActor
    private func renderTemplate() {
        let size = CGSize(width: 400, height: templateHeight)
        let view = AnyView(templateView)
        renderedImage = templateRenderer.render(view, size: size)

        Task {
            await autoSave()
        }
    }

    /// Selecteert de juiste templateview op basis van de sessieconfiguratie.
    @ViewBuilder
    private var templateView: some View {
        switch session.configuration {
        case .one:   OneShotTemplateView(photos: session.capturedPhotos, stripText: session.stripText)
        case .two:   TwoShotTemplateView(photos: session.capturedPhotos, stripText: session.stripText)
        case .three: ThreeShotTemplateView(photos: session.capturedPhotos, stripText: session.stripText)
        }
    }

    private var templateHeight: CGFloat {
        switch session.configuration {
        case .one:   return 560
        case .two:   return 900
        case .three: return 1240
        }
    }

    @MainActor
    private func autoSave() async {
        guard let image = renderedImage else { return }
        isSaving = true
        do {
            try await photoLibraryService.save(image)
            autoSaveCompleted = true
        } catch {
            saveError = error.localizedDescription
        }
        isSaving = false
    }

    func share() {
        guard let image = renderedImage else { return }
        isPreparingShare = true
        Task { @MainActor in
            // Yield enough frames for SwiftUI to render the spinner
            // before UIActivityViewController blocks the main thread.
            try? await Task.sleep(for: .milliseconds(150))

            let url = await Task.detached(priority: .userInitiated) {
                let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent("fotostrip.jpg")
                if let data = image.jpegData(compressionQuality: 0.95) {
                    try? data.write(to: url)
                }
                return url
            }.value

            self.shareURL = url
            self.showShareSheet = true
            // isPreparingShare stays true while the sheet is presenting;
            // reset it once the sheet is dismissed.
        }
    }

    func onShareDismissed() {
        isPreparingShare = false
    }

    func discard() {
        onDiscard?()
    }
}
