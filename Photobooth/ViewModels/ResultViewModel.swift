import SwiftUI

@Observable
final class ResultViewModel {

    let session: PhotoboothSession
    var renderedImage: UIImage?
    var editableStripText: String
    var selectedBackgroundStyle: StripBackgroundStyle
    var selectedFilter: PhotoFilterOption
    var selectedPhotoFrameStyle: PhotoFrameStyle
    var isSaving = false
    var isRenderingPreview = false
    var hasUnsavedChanges = false
    var saveError: String?
    var showShareSheet = false
    var hasSavedToPhotoLibrary = false
    var showSaveConfirmation = false
    var shareURL: URL?
    var isPreparingShare = false

    var onDiscard: (() -> Void)?

    private let photoLibraryService = PhotoLibraryService()
    private let templateRenderer = TemplateRenderer()
    private var renderTask: Task<Void, Never>?
    private var saveConfirmationTask: Task<Void, Never>?
    private var hasRenderedInitialPreview = false

    init(session: PhotoboothSession) {
        self.session = session
        self.editableStripText = session.stripText
        self.selectedBackgroundStyle = session.stripBackgroundStyle
        self.selectedFilter = session.photoFilter
        self.selectedPhotoFrameStyle = session.photoFrameStyle
    }

    @MainActor
    func onAppear() {
        guard !hasRenderedInitialPreview else { return }
        syncDraftToSession()
        renderTemplate()
        hasRenderedInitialPreview = true
    }

    @MainActor
    private func renderTemplate() {
        isRenderingPreview = true
        let size = CGSize(width: 400, height: templateHeight)
        let view = AnyView(templateView)
        renderedImage = templateRenderer.render(view, size: size)
        isRenderingPreview = false
    }

    /// Selecteert de juiste templateview op basis van de sessieconfiguratie.
    @ViewBuilder
    private var templateView: some View {
        switch session.configuration {
        case .one:
            OneShotTemplateView(
                photos: session.capturedPhotos,
                stripText: session.stripText,
                stripBackgroundStyle: session.stripBackgroundStyle,
                photoFilter: session.photoFilter,
                photoFrameStyle: session.photoFrameStyle
            )
        case .two:
            TwoShotTemplateView(
                photos: session.capturedPhotos,
                stripText: session.stripText,
                stripBackgroundStyle: session.stripBackgroundStyle,
                photoFilter: session.photoFilter,
                photoFrameStyle: session.photoFrameStyle
            )
        case .three:
            ThreeShotTemplateView(
                photos: session.capturedPhotos,
                stripText: session.stripText,
                stripBackgroundStyle: session.stripBackgroundStyle,
                photoFilter: session.photoFilter,
                photoFrameStyle: session.photoFrameStyle
            )
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
    func updateStripText(_ text: String) {
        editableStripText = text
        applyDraftChange(debounceMilliseconds: 1000)
    }

    @MainActor
    func selectBackgroundStyle(_ style: StripBackgroundStyle) {
        guard selectedBackgroundStyle != style else { return }
        selectedBackgroundStyle = style
        applyDraftChange()
    }

    @MainActor
    func selectFilter(_ filter: PhotoFilterOption) {
        guard selectedFilter != filter else { return }
        selectedFilter = filter
        applyDraftChange()
    }

    @MainActor
    func selectPhotoFrameStyle(_ style: PhotoFrameStyle) {
        guard selectedPhotoFrameStyle != style else { return }
        selectedPhotoFrameStyle = style
        applyDraftChange()
    }

    @MainActor
    func saveCurrentPreview() {
        Task {
            await saveRenderedImage()
        }
    }

    @MainActor
    private func applyDraftChange(debounceMilliseconds: UInt64 = 100) {
        syncDraftToSession()
        hasUnsavedChanges = true
        hasSavedToPhotoLibrary = false
        showSaveConfirmation = false
        saveConfirmationTask?.cancel()
        rerenderPreview(debounceMilliseconds: debounceMilliseconds)
    }

    @MainActor
    private func syncDraftToSession() {
        session.stripText = editableStripText
        session.stripBackgroundStyle = selectedBackgroundStyle
        session.photoFilter = selectedFilter
        session.photoFrameStyle = selectedPhotoFrameStyle
    }

    @MainActor
    private func rerenderPreview(debounceMilliseconds: UInt64) {
        renderTask?.cancel()
        isRenderingPreview = true

        renderTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(debounceMilliseconds))
            guard !Task.isCancelled else { return }
            renderedImage = nil
            renderTemplate()
        }
    }

    @MainActor
    private func saveRenderedImage() async {
        guard let image = renderedImage else { return }
        isSaving = true
        saveError = nil
        do {
            try await photoLibraryService.save(image)
            hasSavedToPhotoLibrary = true
            hasUnsavedChanges = false
            showSaveConfirmation = true
            saveConfirmationTask?.cancel()
            saveConfirmationTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { return }
                showSaveConfirmation = false
            }
        } catch {
            saveError = error.localizedDescription
            showSaveConfirmation = false
        }
        isSaving = false
    }

    func share() {
        guard let image = renderedImage, !isRenderingPreview else { return }
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
