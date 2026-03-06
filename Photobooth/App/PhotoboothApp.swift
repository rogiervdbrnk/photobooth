import SwiftUI

@main
struct PhotoboothApp: App {
    @State private var coordinator = AppCoordinator()
    @State private var cameraService = CameraService()

    var body: some Scene {
        WindowGroup {
            AppRootView(coordinator: coordinator, cameraService: cameraService)
                .preferredColorScheme(.dark)
        }
    }
}
