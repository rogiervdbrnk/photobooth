# Photobooth App — Implementatieplan
## Verjaardagsthema: Loïs wordt 13!

**Doelplatform:** iOS 16+  
**Taal:** Swift 5.9  
**UI-framework:** SwiftUI  
**Architectuur:** MVVM + Service Layer  
**Taal in de app:** Nederlands  

---

## Inhoudsopgave

1. [Projectstructuur](#1-projectstructuur)
2. [App-flow overzicht](#2-app-flow-overzicht)
3. [Stap 1 — Xcode-project aanmaken](#stap-1--xcode-project-aanmaken)
4. [Stap 2 — Permissions & Info.plist](#stap-2--permissions--infoplist)
5. [Stap 3 — Models](#stap-3--models)
6. [Stap 4 — Services](#stap-4--services)
7. [Stap 5 — ViewModels](#stap-5--viewmodels)
8. [Stap 6 — Views](#stap-6--views)
9. [Stap 7 — Templates](#stap-7--templates)
10. [Stap 8 — Template Renderer](#stap-8--template-renderer)
11. [Stap 9 — Resultaatscherm & Delen](#stap-9--resultaatscherm--delen)
12. [Stap 10 — Navigatie & App-entry](#stap-10--navigatie--app-entry)
13. [Stap 11 — Testen](#stap-11--testen)
14. [Technische beslissingen & richtlijnen](#technische-beslissingen--richtlijnen)
15. [Template ontwerpen (visueel)](#template-ontwerpen-visueel)

---

## 1. Projectstructuur

```
Photobooth/
├── App/
│   ├── PhotoboothApp.swift          ← @main entry point
│   └── AppCoordinator.swift         ← Navigatiebeheer
├── Models/
│   ├── ShotConfiguration.swift      ← Aantal shots (1-3)
│   └── PhotoboothSession.swift      ← Vastgelegde foto's + configuratie
├── Services/
│   ├── CameraService.swift          ← AVFoundation wrapper
│   ├── PermissionService.swift      ← Camera + fotobibliotheek rechten
│   ├── PhotoLibraryService.swift    ← Opslaan naar Camera Rol
│   └── TemplateRenderer.swift       ← Renders SwiftUI view → UIImage
├── ViewModels/
│   ├── ShotSelectionViewModel.swift
│   ├── CameraViewModel.swift
│   └── ResultViewModel.swift
├── Views/
│   ├── ShotSelectionView.swift      ← Scherm 1: kies aantal shots
│   ├── CameraView.swift             ← Scherm 2: camerascherm
│   ├── CountdownOverlayView.swift   ← Aftellen + shot-indicator
│   └── ResultView.swift             ← Scherm 3: eindresultaat
├── Templates/
│   ├── TemplateView.swift           ← Protocol + dispatch
│   ├── OneShot TemplateView.swift   ← 1-foto template
│   ├── TwoShotTemplateView.swift    ← 2-foto template
│   └── ThreeShotTemplateView.swift  ← 3-foto template
├── Components/
│   ├── CameraPreviewView.swift      ← UIViewRepresentable voor AVCaptureVideoPreviewLayer
│   └── ShotProgressView.swift      ← Bolletjes die voortgang tonen
└── Assets.xcassets/
    ├── AppIcon
    ├── Colors/
    │   ├── BirthdayPink
    │   ├── BirthdayGold
    │   └── BirthdayPurple
    └── Images/
        ├── confetti_pattern          ← achtergrondpatroon
        ├── balloon_left
        ├── balloon_right
        └── star_decoration
```

---

## 2. App-flow overzicht

```
[Start]
   │
   ▼
ShotSelectionView
  "Hoeveel foto's wil je maken?"
  ● 1 foto   ● 2 foto's   ● 3 foto's
   │
   ▼
PermissionService.requestAll()
  ├── Geweigerd → AlertView → Settings
  └── Toegestaan ────────────────────┐
                                     ▼
                               CameraView
                         (selfie-camera actief)
                          [Tik op "Foto maken"]
                                     │
                              CountdownOverlay
                              3 … 2 … 1 … 📸
                                     │
                              Shot opgeslagen in sessie
                                     │
                         [Nog shots over?]
                          ├── Ja → ShotProgressView update
                          │        + volgende aftelling
                          └── Nee → TemplateRenderer
                                          │
                                          ▼
                                    ResultView
                             [Delen / Opslaan]  [Opnieuw]
                                     │
                       PhotoLibraryService.save() (automatisch)
                       +  UIActivityViewController (delen)
```

---

## Stap 1 — Xcode-project aanmaken

### Acties

1. Open Xcode → **File > New > Project**
2. Kies **iOS → App**
3. Vul in:
   - **Product Name:** `Photobooth`
   - **Team:** jouw Apple Developer account
   - **Organization Identifier:** `nl.jouwbedrijf` (of persoonlijk domein)
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Minimum Deployments:** iOS 16.0
4. Sla op in `/Users/rogiervandenbrink/Projects/photobooth/`
5. Schakel **Portrait only** in via *Target → General → Device Orientation* (portrait + upside-down uitvinken)
6. Maak de submappen aan zoals beschreven in de projectstructuur

---

## Stap 2 — Permissions & Info.plist

### Toe te voegen sleutels aan Info.plist

```xml
<!-- Cameratoegang -->
<key>NSCameraUsageDescription</key>
<string>De Photobooth-app gebruikt de camera om foto's te maken voor jouw verjaardagsstrip.</string>

<!-- Fotobibliotheektoegang (schrijven) -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>De Photobooth-app slaat jouw gemaakte fotostrip automatisch op in je Fotobibliotheek.</string>

<!-- Fotobibliotheektoegang (lezen — iOS 14+ niet verplicht voor alleen schrijven, maar goed om toe te voegen) -->
<key>NSPhotoLibraryUsageDescription</key>
<string>De Photobooth-app heeft toegang nodig tot je Fotobibliotheek om de fotostrip op te slaan.</string>
```

> **Let op:** Zonder deze sleutels crasht de app direct bij het opvragen van toestemming. Voeg ze toe VÓÓR je de permission requests implementeert.

### PermissionService.swift

```swift
import AVFoundation
import Photos

/// Beheert alle toestemmingsverzoeken voor camera en fotobibliotheek.
final class PermissionService {

    enum PermissionError: LocalizedError {
        case cameraDenied
        case photoLibraryDenied

        var errorDescription: String? {
            switch self {
            case .cameraDenied:
                return "Cameratoegang is geweigerd. Ga naar Instellingen om dit te wijzigen."
            case .photoLibraryDenied:
                return "Toegang tot de Fotobibliotheek is geweigerd. Ga naar Instellingen om dit te wijzigen."
            }
        }
    }

    /// Vraagt zowel camera- als fotobibliotheektoegang op.
    /// Returns true als beide zijn toegestaan.
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
```

---

## Stap 3 — Models

### ShotConfiguration.swift

```swift
import Foundation

/// Hoeveel foto's de gebruiker wil maken: 1, 2 of 3.
enum ShotConfiguration: Int, CaseIterable, Identifiable {
    case one   = 1
    case two   = 2
    case three = 3

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .one:   return "1 foto"
        case .two:   return "2 foto's"
        case .three: return "3 foto's"
        }
    }

    var description: String {
        switch self {
        case .one:   return "Eén mooie shot voor de strip"
        case .two:   return "Twee shots naast elkaar"
        case .three: return "Drie shots, de klassieke fotostrip"
        }
    }
}
```

### PhotoboothSession.swift

```swift
import UIKit

/// Bevat de staat van één photobooth-sessie: configuratie + gemaakte foto's.
@Observable
final class PhotoboothSession {
    let configuration: ShotConfiguration
    private(set) var capturedPhotos: [UIImage] = []

    init(configuration: ShotConfiguration) {
        self.configuration = configuration
    }

    var totalShots: Int { configuration.rawValue }
    var shotsTaken: Int { capturedPhotos.count }
    var remainingShots: Int { totalShots - shotsTaken }
    var isComplete: Bool { shotsTaken == totalShots }

    func addPhoto(_ image: UIImage) {
        guard capturedPhotos.count < totalShots else { return }
        capturedPhotos.append(image)
    }

    func reset() {
        capturedPhotos.removeAll()
    }
}
```

---

## Stap 4 — Services

### CameraService.swift

```swift
import AVFoundation
import UIKit

/// Beheert de AVFoundation capture session en het nemen van foto's.
@Observable
final class CameraService: NSObject {

    // MARK: - Public state
    var captureSession = AVCaptureSession()
    var error: Error?

    // MARK: - Private
    private var photoOutput = AVCapturePhotoOutput()
    private var continuation: CheckedContinuation<UIImage, Error>?

    // MARK: - Setup

    /// Configureert de sessie met de frontcamera.
    func configure() throws {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo

        // Frontcamera ophalen
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera, for: .video, position: .front
        ) else {
            throw CameraError.deviceNotFound
        }

        let input = try AVCaptureDeviceInput(device: device)
        guard captureSession.canAddInput(input) else {
            throw CameraError.cannotAddInput
        }
        captureSession.addInput(input)

        guard captureSession.canAddOutput(photoOutput) else {
            throw CameraError.cannotAddOutput
        }
        captureSession.addOutput(photoOutput)

        captureSession.commitConfiguration()
    }

    func start() {
        guard !captureSession.isRunning else { return }
        Task.detached { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func stop() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
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
            case .deviceNotFound:  return "Frontcamera niet gevonden."
            case .cannotAddInput:  return "Kan camera niet verbinden."
            case .cannotAddOutput: return "Kan foto-uitvoer niet instellen."
            case .captureFailed:   return "Foto maken mislukt."
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraService: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error {
            continuation?.resume(throwing: error)
            continuation = nil
            return
        }

        guard
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            continuation?.resume(throwing: CameraError.captureFailed)
            continuation = nil
            return
        }

        // Frontcamera-foto horizontaal spiegelen zodat het een 'spiegel'-resultaat geeft
        let mirrored = UIImage(cgImage: image.cgImage!,
                               scale: image.scale,
                               orientation: .leftMirrored)
        continuation?.resume(returning: mirrored)
        continuation = nil
    }
}
```

### PhotoLibraryService.swift

```swift
import Photos
import UIKit

/// Slaat een UIImage op in de Camera Rol van het apparaat.
final class PhotoLibraryService {

    enum SaveError: LocalizedError {
        case saveFailed(Error)

        var errorDescription: String? {
            if case .saveFailed(let e) = self {
                return "Opslaan mislukt: \(e.localizedDescription)"
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
```

### TemplateRenderer.swift

```swift
import SwiftUI
import UIKit

/// Rendert een SwiftUI-templateview naar een UIImage.
final class TemplateRenderer {

    /// - Parameters:
    ///   - view: De te renderen SwiftUI-view
    ///   - size: De gewenste uitvoergrootte in punten (wordt @3x geschaald)
    @MainActor
    func render<V: View>(_ view: V, size: CGSize) -> UIImage {
        let renderer = ImageRenderer(content:
            view.frame(width: size.width, height: size.height)
        )
        renderer.scale = 3.0  // @3x voor hoge kwaliteit
        return renderer.uiImage ?? UIImage()
    }
}
```

---

## Stap 5 — ViewModels

### ShotSelectionViewModel.swift

```swift
import Foundation

@Observable
final class ShotSelectionViewModel {
    var selectedConfiguration: ShotConfiguration = .three
    var showPermissionAlert = false
    var permissionError: String?

    private let permissionService = PermissionService()

    // Callback naar AppCoordinator zodra we door mogen
    var onConfirm: ((ShotConfiguration) -> Void)?

    func confirm() {
        Task { @MainActor in
            do {
                try await permissionService.requestAll()
                onConfirm?(selectedConfiguration)
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
```

### CameraViewModel.swift

```swift
import SwiftUI

@Observable
final class CameraViewModel {

    // MARK: - State
    var countdownValue: Int? = nil          // nil = geen aftelling actief
    var isCapturing = false
    var currentShotIndex = 0               // 0-gebaseerd
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
        }
    }

    func onDisappear() {
        cameraService.stop()
    }

    // MARK: - Foto-flow

    /// Start de aftelling en maakt daarna een foto.
    func startCountdownAndCapture() {
        guard !isCapturing else { return }
        isCapturing = true

        Task { @MainActor in
            // Aftelling: 3, 2, 1
            for i in stride(from: 3, through: 1, by: -1) {
                countdownValue = i
                try? await Task.sleep(for: .seconds(1))
            }
            countdownValue = nil

            // Flash-effect
            showFlash = true
            try? await Task.sleep(for: .milliseconds(200))
            showFlash = false

            // Foto nemen
            do {
                let image = try await cameraService.capturePhoto()
                session.addPhoto(image)
                currentShotIndex = session.shotsTaken

                if session.isComplete {
                    isCapturing = false
                    onSessionComplete?(session)
                } else {
                    // Korte pauze voor de volgende shot
                    try? await Task.sleep(for: .seconds(1))
                    isCapturing = false
                }
            } catch {
                self.error = error.localizedDescription
                isCapturing = false
            }
        }
    }
}
```

### ResultViewModel.swift

```swift
import SwiftUI

@Observable
final class ResultViewModel {

    let session: PhotoboothSession
    var renderedImage: UIImage?
    var isSaving = false
    var saveError: String?
    var showShareSheet = false
    var autoSaveCompleted = false

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
        let templateView = TemplateView.make(for: session)
        renderedImage = templateRenderer.render(templateView, size: size)

        // Automatisch opslaan zodra de template gereed is
        Task {
            await autoSave()
        }
    }

    /// Hoogte van de template op basis van het aantal shots.
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
        showShareSheet = true
    }

    func discard() {
        onDiscard?()
    }
}
```

---

## Stap 6 — Views

### CameraPreviewView.swift (UIViewRepresentable)

```swift
import SwiftUI
import AVFoundation

/// Wikkelt AVCaptureVideoPreviewLayer in een SwiftUI View.
struct CameraPreviewView: UIViewRepresentable {

    let captureSession: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.session = captureSession
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}

    // MARK: - UIView subclass
    final class PreviewUIView: UIView {
        var session: AVCaptureSession? {
            didSet {
                previewLayer.session = session
            }
        }

        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = bounds
            previewLayer.videoGravity = .resizeAspectFill
        }
    }
}
```

### ShotSelectionView.swift

```swift
import SwiftUI

struct ShotSelectionView: View {
    @State private var viewModel = ShotSelectionViewModel()

    var body: some View {
        ZStack {
            // Achtergrond
            LinearGradient(
                colors: [Color("BirthdayPink"), Color("BirthdayPurple")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {

                // Titel
                VStack(spacing: 8) {
                    Text("🎉 Loïs wordt 13! 🎉")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Photobooth")
                        .font(.system(size: 42, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color("BirthdayGold"))
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                }
                .padding(.top, 60)

                // Shot-keuze kaarten
                VStack(spacing: 16) {
                    Text("Hoeveel foto's wil je maken?")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)

                    ForEach(ShotConfiguration.allCases) { config in
                        ShotOptionCard(
                            config: config,
                            isSelected: viewModel.selectedConfiguration == config
                        ) {
                            viewModel.selectedConfiguration = config
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Doorgaan-knop
                Button(action: viewModel.confirm) {
                    HStack {
                        Text("Start de photobooth!")
                            .font(.title3.weight(.bold))
                        Image(systemName: "camera.fill")
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color("BirthdayGold"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color("BirthdayGold").opacity(0.5), radius: 8, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .alert("Toestemming vereist", isPresented: $viewModel.showPermissionAlert) {
            Button("Open Instellingen") { viewModel.openSettings() }
            Button("Annuleer", role: .cancel) {}
        } message: {
            Text(viewModel.permissionError ?? "")
        }
    }
}

// MARK: - ShotOptionCard
private struct ShotOptionCard: View {
    let config: ShotConfiguration
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Foto-icoon(en)
                HStack(spacing: 4) {
                    ForEach(0..<config.rawValue, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isSelected ? Color("BirthdayGold") : Color.white.opacity(0.4))
                            .frame(width: 28, height: 36)
                    }
                }
                .frame(width: 100)

                VStack(alignment: .leading, spacing: 4) {
                    Text(config.displayName)
                        .font(.headline)
                        .foregroundStyle(isSelected ? Color("BirthdayGold") : .white)
                    Text(config.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color("BirthdayGold") : .white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .white.opacity(0.25) : .white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color("BirthdayGold") : .clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
```

### ShotProgressView.swift

```swift
import SwiftUI

/// Toont bolletjes die aangeven hoeveel shots al gemaakt zijn.
struct ShotProgressView: View {
    let total: Int
    let taken: Int

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index < taken ? Color("BirthdayGold") : Color.white.opacity(0.4))
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .scaleEffect(index < taken ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3), value: taken)
            }
        }
    }
}
```

### CameraView.swift

```swift
import SwiftUI

struct CameraView: View {
    @State var viewModel: CameraViewModel

    var body: some View {
        ZStack {
            // Camera preview (vult het scherm)
            CameraPreviewView(captureSession: viewModel.cameraService.captureSession)
                .ignoresSafeArea()

            // Flash-overlay bij het nemen van een foto
            if viewModel.showFlash {
                Color.white
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            // UI-overlay
            VStack {
                // Bovenbalk: voortgang
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Shot \(viewModel.currentShotIndex + 1) van \(viewModel.session.totalShots)")
                            .font(.headline)
                            .foregroundStyle(.white)
                        ShotProgressView(
                            total: viewModel.session.totalShots,
                            taken: viewModel.session.shotsTaken
                        )
                    }
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)

                Spacer()

                // Aftelling
                if let countdown = viewModel.countdownValue {
                    Text("\(countdown)")
                        .font(.system(size: 120, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 8)
                        .transition(.scale.combined(with: .opacity))
                        .id(countdown) // forceert animatie bij elke waarde
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: countdown)
                }

                Spacer()

                // Onderbalk
                VStack(spacing: 16) {
                    if viewModel.session.remainingShots > 0 && !viewModel.isCapturing {
                        Text(viewModel.session.shotsTaken == 0
                             ? "Klaar voor je foto?"
                             : "Nog \(viewModel.session.remainingShots) shot\(viewModel.session.remainingShots > 1 ? "s" : "") te gaan!")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }

                    // Sluitersknop
                    Button(action: viewModel.startCountdownAndCapture) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 80, height: 80)
                            Circle()
                                .stroke(.white.opacity(0.5), lineWidth: 6)
                                .frame(width: 96, height: 96)
                        }
                    }
                    .disabled(viewModel.isCapturing)
                    .opacity(viewModel.isCapturing ? 0.5 : 1.0)
                }
                .padding(.bottom, 48)
            }
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .alert("Fout", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") { viewModel.error = nil }
        } message: {
            Text(viewModel.error ?? "")
        }
    }
}
```

### ResultView.swift

```swift
import SwiftUI

struct ResultView: View {
    @State var viewModel: ResultViewModel

    var body: some View {
        ZStack {
            // Achtergrond
            LinearGradient(
                colors: [Color("BirthdayPurple"), Color("BirthdayPink")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    Text("Jullie fotostrip! 🎂")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.top, 32)

                    // Template preview
                    if let image = viewModel.renderedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
                            .padding(.horizontal, 24)
                    } else {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                            .frame(height: 300)
                    }

                    // Opslagstatus
                    if viewModel.isSaving {
                        HStack {
                            ProgressView()
                                .tint(.white)
                            Text("Opslaan naar Fotobibliotheek…")
                                .foregroundStyle(.white)
                                .font(.subheadline)
                        }
                    } else if viewModel.autoSaveCompleted {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Automatisch opgeslagen!")
                        }
                        .foregroundStyle(.white)
                        .font(.subheadline)
                    }

                    // Actieknoppen
                    VStack(spacing: 12) {
                        // Delen
                        Button(action: viewModel.share) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Deel de fotostrip")
                            }
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color("BirthdayGold"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }

                        // Opnieuw
                        Button(action: viewModel.discard) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Opnieuw beginnen")
                            }
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let image = viewModel.renderedImage {
                ShareSheet(activityItems: [image])
            }
        }
        .alert("Opslaan mislukt", isPresented: .constant(viewModel.saveError != nil)) {
            Button("OK") { viewModel.saveError = nil }
        } message: {
            Text(viewModel.saveError ?? "")
        }
    }
}

// MARK: - ShareSheet (UIActivityViewController wrapper)
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
```

---

## Stap 7 — Templates

### Kleurpalet (Assets.xcassets)

Maak de volgende kleuren aan in **Assets.xcassets → New Color Set**:

| Naam             | Light Mode         | Dark Mode |
|------------------|--------------------|-----------|
| `BirthdayPink`   | `#FF6B9D`          | `#FF6B9D` |
| `BirthdayGold`   | `#FFD700`          | `#FFD700` |
| `BirthdayPurple` | `#9B59B6`          | `#9B59B6` |
| `BirthdayMint`   | `#A8E6CF`          | `#A8E6CF` |

### TemplateView.swift (dispatch helper)

```swift
import SwiftUI

/// Kiest de juiste templateview op basis van het aantal shots in de sessie.
@ViewBuilder
func TemplateView(for session: PhotoboothSession) -> some View {
    switch session.configuration {
    case .one:   OneShotTemplateView(photos: session.capturedPhotos)
    case .two:   TwoShotTemplateView(photos: session.capturedPhotos)
    case .three: ThreeShotTemplateView(photos: session.capturedPhotos)
    }
}

// Convenience extension voor TemplateRenderer
extension TemplateView {
    @MainActor
    static func make(for session: PhotoboothSession) -> some View {
        AnyView(TemplateView(for: session))
    }
}
```

### OneShotTemplateView.swift

```swift
import SwiftUI

/// Template voor 1 foto — brede, staande fotostrip.
struct OneShotTemplateView: View {
    let photos: [UIImage]

    var body: some View {
        ZStack {
            // ── Achtergrond ─────────────────────────────────────
            Color(hex: "#2D0A4E")           // dieppaars

            // Confetti-stippen patroon
            ConfettiPatternView()

            // ── Kaart ────────────────────────────────────────────
            VStack(spacing: 0) {

                // Boventekst banner
                ZStack {
                    Color(hex: "#FF6B9D")
                    Text("🎂 Loïs wordt 13! 🎂")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                }

                // Foto
                if let photo = photos.first {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 360, height: 360)
                        .clipped()
                        .padding(12)
                        .background(.white)
                }

                // Decoratieve label-strip
                ZStack {
                    Color(hex: "#FFD700")
                    HStack {
                        Text("⭐️")
                        Text("Happy Birthday!")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#2D0A4E"))
                        Text("⭐️")
                    }
                    .padding(.vertical, 10)
                }

                // Ondertekst
                ZStack {
                    Color(hex: "#9B59B6")
                    VStack(spacing: 4) {
                        Text("Photobooth @ Loïs 13")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("🎈 🎉 🎈")
                            .font(.title2)
                    }
                    .padding(.vertical, 12)
                }
            }
            .frame(width: 384)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.5), radius: 16, y: 8)
        }
        .frame(width: 400, height: 560)
    }
}
```

### TwoShotTemplateView.swift

```swift
import SwiftUI

/// Template voor 2 foto's — klassieke dubbele fotostrip.
struct TwoShotTemplateView: View {
    let photos: [UIImage]

    var body: some View {
        ZStack {
            Color(hex: "#1A0033")
            ConfettiPatternView()
            StarDecorationView()

            VStack(spacing: 0) {

                // Boventekst
                ZStack {
                    Color(hex: "#FF6B9D")
                    VStack(spacing: 2) {
                        Text("🎂 Loïs wordt 13! 🎂")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Fotostrip")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.vertical, 14)
                }

                // Twee foto's
                VStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { index in
                        if index < photos.count {
                            Image(uiImage: photos[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 360, height: 280)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 360, height: 280)
                        }
                    }
                }
                .padding(12)
                .background(.white)

                // Midden-label
                ZStack {
                    Color(hex: "#FFD700")
                    HStack(spacing: 12) {
                        Text("🎈")
                        Text("Happy 13th Birthday!")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#2D0A4E"))
                        Text("🎈")
                    }
                    .padding(.vertical, 10)
                }

                // Onderste balk
                ZStack {
                    Color(hex: "#9B59B6")
                    HStack {
                        Text("🌟 Loïs • 13 jaar 🌟")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 12)
                }
            }
            .frame(width: 384)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.5), radius: 16, y: 8)
        }
        .frame(width: 400, height: 900)
    }
}
```

### ThreeShotTemplateView.swift

```swift
import SwiftUI

/// Template voor 3 foto's — de klassieke photobooth-strip.
struct ThreeShotTemplateView: View {
    let photos: [UIImage]

    var body: some View {
        ZStack {
            Color(hex: "#1A0033")
            ConfettiPatternView()
            StarDecorationView()

            VStack(spacing: 0) {

                // Top banner
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#FF6B9D"), Color(hex: "#9B59B6")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    VStack(spacing: 3) {
                        Text("🎂 Loïs wordt 13! 🎂")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                        Text("De klassieke fotostrip")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.vertical, 16)
                }

                // Drie foto's
                VStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        ZStack(alignment: .bottomTrailing) {
                            if index < photos.count {
                                Image(uiImage: photos[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 360, height: 240)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 360, height: 240)
                            }

                            // Shot nummerlabel
                            Text("#\(index + 1)")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#FF6B9D").opacity(0.85))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .padding(8)
                        }
                    }
                }
                .padding(12)
                .background(.white)

                // Midden-strip met sterren
                ZStack {
                    Color(hex: "#FFD700")
                    Text("⭐️  Happy 13th Birthday Loïs!  ⭐️")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#2D0A4E"))
                        .padding(.vertical, 10)
                }

                // Onderste balk
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "#9B59B6"), Color(hex: "#FF6B9D")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    HStack(spacing: 16) {
                        Text("🎈")
                        Text("Loïs • 13 jaar • Photobooth")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("🎈")
                    }
                    .padding(.vertical, 14)
                }
            }
            .frame(width: 384)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.5), radius: 16, y: 8)
        }
        .frame(width: 400, height: 1240)
    }
}
```

### Decoratieve hulpviews

```swift
// ConfettiPatternView.swift
import SwiftUI

/// Genereert een willekeurig confetti-patroon als achtergrond.
struct ConfettiPatternView: View {
    private struct Dot: Identifiable {
        let id = UUID()
        let x, y, size: CGFloat
        let color: Color
    }

    private let dots: [Dot] = {
        let colors: [Color] = [.pink, .yellow, .purple, .mint, .orange, .white]
        return (0..<80).map { _ in
            Dot(
                x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: 0...1300),
                size: CGFloat.random(in: 4...12),
                color: colors.randomElement()!
            )
        }
    }()

    var body: some View {
        Canvas { context, _ in
            for dot in dots {
                let rect = CGRect(x: dot.x, y: dot.y, width: dot.size, height: dot.size)
                context.fill(
                    Ellipse().path(in: rect),
                    with: .color(dot.color.opacity(0.4))
                )
            }
        }
        .allowsHitTesting(false)
    }
}

// StarDecorationView.swift
import SwiftUI

/// Voegt grote decoratieve sterren toe aan de achtergrond.
struct StarDecorationView: View {
    var body: some View {
        ZStack {
            Text("⭐️").font(.system(size: 60)).position(x: 30, y: 80).opacity(0.3)
            Text("🎂").font(.system(size: 50)).position(x: 370, y: 120).opacity(0.25)
            Text("🎈").font(.system(size: 55)).position(x: 20, y: 700).opacity(0.3)
            Text("✨").font(.system(size: 45)).position(x: 380, y: 900).opacity(0.3)
        }
        .allowsHitTesting(false)
    }
}
```

### Color(hex:) extension

```swift
import SwiftUI

extension Color {
    /// Initialiseer een Color met een hexadecimale string zoals "#FF6B9D".
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int & 0xFF)          / 255
        self.init(red: r, green: g, blue: b)
    }
}
```

---

## Stap 8 — Template Renderer

> Al geïmplementeerd in Stap 4 (`TemplateRenderer.swift`).

**Aandachtspunten:**
- `ImageRenderer` werkt alleen op de **main thread** — altijd aanroepen met `@MainActor`.
- De `scale: 3.0` zorgt voor een @3x afbeelding (hoge kwaliteit bij shared output).
- Zorg dat `TemplateView.make(for:)` de juiste `AnyView` teruggeeft.
- Test de gerenderde afmetingen op een echte device; de hoogte per configuratie staat in `ResultViewModel.templateHeight`.

---

## Stap 9 — Resultaatscherm & Delen

> `ResultView.swift` en `ResultViewModel.swift` zijn al volledig uitgewerkt in stap 5 en 6.

**Samenvatting van de logica:**

```
onAppear()
  │
  ├── renderTemplate()       ← TemplateRenderer → UIImage
  │     └── autoSave()       ← PhotoLibraryService.save()
  │
  └── share()                ← showShareSheet = true
        └── ShareSheet        ← UIActivityViewController met de UIImage
```

**Automatisch opslaan:**  
De foto wordt automatisch opgeslagen zodra `ResultView` verschijnt. De gebruiker ziet een vinkje (`✓ Automatisch opgeslagen!`) wanneer dit gelukt is. Na het delen via `ShareSheet` kan de gebruiker de foto ook opnieuw opslaan vanuit het share-scherm — dit is iOS-standaardgedrag.

---

## Stap 10 — Navigatie & App-entry

### AppCoordinator.swift

```swift
import SwiftUI

/// Beheert de navigatiestatus van de app.
@Observable
final class AppCoordinator {

    enum Screen {
        case shotSelection
        case camera(PhotoboothSession)
        case result(PhotoboothSession)
    }

    var currentScreen: Screen = .shotSelection

    func goToCamera(with config: ShotConfiguration) {
        let session = PhotoboothSession(configuration: config)
        currentScreen = .camera(session)
    }

    func goToResult(with session: PhotoboothSession) {
        currentScreen = .result(session)
    }

    func restart() {
        currentScreen = .shotSelection
    }
}
```

### PhotoboothApp.swift

```swift
import SwiftUI

@main
struct PhotoboothApp: App {
    @State private var coordinator = AppCoordinator()
    @State private var cameraService = CameraService()

    var body: some Scene {
        WindowGroup {
            AppRootView(coordinator: coordinator, cameraService: cameraService)
        }
    }
}
```

### AppRootView.swift

```swift
import SwiftUI

struct AppRootView: View {
    let coordinator: AppCoordinator
    let cameraService: CameraService

    var body: some View {
        switch coordinator.currentScreen {

        case .shotSelection:
            ShotSelectionView(
                viewModel: {
                    let vm = ShotSelectionViewModel()
                    vm.onConfirm = { config in
                        coordinator.goToCamera(with: config)
                    }
                    return vm
                }()
            )
            .transition(.opacity)

        case .camera(let session):
            CameraView(
                viewModel: {
                    let vm = CameraViewModel(
                        session: session,
                        cameraService: cameraService
                    )
                    vm.onSessionComplete = { completedSession in
                        coordinator.goToResult(with: completedSession)
                    }
                    return vm
                }()
            )
            .transition(.move(edge: .trailing))

        case .result(let session):
            ResultView(
                viewModel: {
                    let vm = ResultViewModel(session: session)
                    vm.onDiscard = {
                        coordinator.restart()
                    }
                    return vm
                }()
            )
            .transition(.move(edge: .trailing))
        }
    }
}
```

> **Let op:** Wikkel `AppRootView` in een `withAnimation(.easeInOut(duration: 0.35))` wanneer `coordinator.currentScreen` wijzigt voor vloeiende schermovergangen. Dit doe je door de coordinator's `currentScreen` te wikkelen in een setter met `withAnimation`.

---

## Stap 11 — Testen

### Unit tests

| Test | Bestand | Wat testen |
|------|---------|------------|
| `PhotoboothSessionTests` | `PhotoboothSessionTests.swift` | `addPhoto()`, `isComplete`, `remainingShots` |
| `ShotConfigurationTests` | `ShotConfigurationTests.swift` | `displayName`, `rawValue`, `allCases` |
| `PermissionServiceTests` | `PermissionServiceTests.swift` | Mock AVFoundation & PHPhotoLibrary |

### UI tests (XCTest / XCUITest)

| Scenario | Actie |
|----------|-------|
| Selecteer 1 shot en ga door | Tik op "1 foto" kaart → tik "Start de photobooth!" → verwacht CameraView |
| Aftelling zichtbaar | Tik sluiterknop → verwacht label "3", "2", "1" op scherm |
| Resultaat getoond | Na voltooien van alle shots → verwacht ResultView met template |

### Handmatig testen (checklist)

- [ ] Camera opent op de frontcamera
- [ ] Aftelling telt correct af (3→2→1)
- [ ] Foto wordt correct weergegeven in template
- [ ] Foto wordt automatisch opgeslagen in Camera Rol
- [ ] Delen-sheet opent met de correcte afbeelding
- [ ] Toestemmings-alert verschijnt bij geweigerde camera
- [ ] Toestemmings-alert verschijnt bij geweigerd fotobibliotheek
- [ ] "Opnieuw beginnen" reset de sessie volledig
- [ ] Alle drie templates renderen correct (1, 2, 3 shots)
- [ ] Tekst is volledig in het Nederlands

---

## Technische beslissingen & richtlijnen

| Beslissing | Keuze | Waarom |
|---|---|---|
| UI-framework | SwiftUI | Modern, minder boilerplate, betere preview-ondersteuning |
| State management | `@Observable` (Observation framework) | iOS 17+, geen `@Published` overhead; vereenvoudigt ViewModels |
| Navigatie | Custom `AppCoordinator` | Eenvoudiger dan NavigationStack voor een lineaire 3-schermenstroom |
| Camera | AVFoundation (direct) | Volledige controle over preview en capture; geen derde partij |
| Foto renderen | `ImageRenderer` (SwiftUI) | Geen UIKit/CoreGraphics nodig; rendert SwiftUI-views direct |
| Async/await | Structured Concurrency | Cleane aftelling en async camera capture zonder callbacks |
| Minimum iOS | iOS 16.0 | `ImageRenderer` vereist iOS 16; `@Observable` vereist iOS 17 — gebruik iOS 17 als minimum |

> **Aanbeveling:** Zet het minimum deployment target op **iOS 17.0** om `@Observable` te kunnen gebruiken zonder bridging.

---

## Template ontwerpen (visueel)

Zie het bestand [TEMPLATE_DESIGNS.md](./TEMPLATE_DESIGNS.md) voor de volledige visuele beschrijvingen en maatschema's van de drie templates.

---

## Volgorde van implementatie (aanbevolen voor een junior engineer)

1. **Project aanmaken + Info.plist** (Stap 1 & 2) — ~30 min
2. **Models** (Stap 3) — ~15 min
3. **PermissionService + PhotoLibraryService** (Stap 4) — ~30 min
4. **CameraService** (Stap 4) — ~45 min
5. **CameraPreviewView** (Stap 6, component) — ~20 min
6. **ShotSelectionView + ViewModel** (Stap 5 & 6) — ~45 min
7. **CameraView + ViewModel** (Stap 5 & 6) — ~60 min
8. **Templates** (Stap 7) — ~90 min
9. **TemplateRenderer** (Stap 4 & 8) — ~20 min
10. **ResultView + ViewModel** (Stap 5 & 6) — ~45 min
11. **AppCoordinator + App entry** (Stap 10) — ~30 min
12. **Testen + bugfixes** (Stap 11) — ~60 min

**Totale schatting: ± 8 uur voor een junior engineer.**
