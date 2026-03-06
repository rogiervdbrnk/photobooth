import SwiftUI

/// Rootview die op basis van de coordinator het juiste scherm toont.
struct AppRootView: View {
    let coordinator: AppCoordinator
    let cameraService: CameraService

    @State private var showSplash = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch coordinator.currentScreen {

            case .shotSelection:
                ShotSelectionView(viewModel: makeShotSelectionVM())
                    .transition(.opacity)

            case .camera(let session):
                CameraView(viewModel: makeCameraVM(session: session))
                    .transition(.move(edge: .trailing))

            case .result(let session):
                ResultView(viewModel: makeResultVM(session: session))
                    .transition(.move(edge: .trailing))
            }

            // ── Splash overlay ──────────────────────────────────
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: coordinator.currentScreen)
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            Task {
                try? await Task.sleep(for: .milliseconds(1600))
                showSplash = false
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    // MARK: - ViewModel factories

    private func makeShotSelectionVM() -> ShotSelectionViewModel {
        let vm = ShotSelectionViewModel()
        vm.onConfirm = { config, stripText in
            coordinator.goToCamera(with: config, stripText: stripText)
        }
        return vm
    }

    private func makeCameraVM(session: PhotoboothSession) -> CameraViewModel {
        let vm = CameraViewModel(session: session, cameraService: cameraService)
        vm.onSessionComplete = { completedSession in
            coordinator.goToResult(with: completedSession)
        }
        return vm
    }

    private func makeResultVM(session: PhotoboothSession) -> ResultViewModel {
        let vm = ResultViewModel(session: session)
        vm.onDiscard = {
            coordinator.restart()
        }
        return vm
    }
}
