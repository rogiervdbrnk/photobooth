import SwiftUI

// Measures the global maxY of the top bar so we can align the preview beneath it.
private struct TopBarMaxYKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

struct CameraView: View {
    @State var viewModel: CameraViewModel
    @State private var topBarMaxY: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ── Camera preview ─────────────────────────────────
                // The photo preset captures at 4:3 (portrait). With resizeAspect the
                // layer centres the preview vertically. We offset it upward so its top
                // edge aligns exactly with the bottom of the progress bar.
                let previewHeight = geo.size.width * 4 / 3
                let naturalTop    = (geo.size.height - previewHeight) / 2
                let previewOffset  = topBarMaxY > 0 ? topBarMaxY - naturalTop : 0
                
                
                CameraPreviewView(captureSession: viewModel.cameraService.captureSession)
                    .ignoresSafeArea()
                    .offset(y: previewOffset)
                
                // ── Flitseffect ────────────────────────────────────
                if viewModel.showFlash {
                    Color.white
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
                
                // ── UI overlay ─────────────────────────────────────
                VStack(spacing: 0) {
                    
                    // Bovenste balk: voortgang
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(String(format: String(localized: "shot_counter_format"), min(viewModel.currentShotIndex + 1, viewModel.session.totalShots), viewModel.session.totalShots))
                                .font(.headline)
                                .foregroundStyle(.white)
                            ShotProgressView(
                                total: viewModel.session.totalShots,
                                taken: viewModel.session.shotsTaken
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .frame(height: naturalTop) // Force the bar to be exactly as tall as the top "letterbox"
                    
                    Spacer()
                    
                    // Aftelling
                    if let countdown = viewModel.countdownValue {
                        Text("\(countdown)")
                            .font(.system(size: 120, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 8)
                            .id(countdown)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 1.5).combined(with: .opacity),
                                removal: .scale(scale: 0.5).combined(with: .opacity)
                            ))
                    }
                    
                    Spacer()
                    
                }
            }
            .onPreferenceChange(TopBarMaxYKey.self) { topBarMaxY = $0 }
            .animation(.easeInOut(duration: 0.15), value: viewModel.showFlash)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.countdownValue)
            .onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
            .alert("Fout", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("OK") { viewModel.error = nil }
            } message: {
                Text(viewModel.error ?? "")
            }
        }
        .ignoresSafeArea()
    }
}
