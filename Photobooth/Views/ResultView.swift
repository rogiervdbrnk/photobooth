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

            GeometryReader { geo in
                VStack(spacing: 16) {

                    Text("Jouw fotostrip! 📸")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.top, 24)

                    // ── Template preview ──────────────────────────
                    Group {
                        if let image = viewModel.renderedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        } else {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.5)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(maxHeight: geo.size.height * 0.60)
                    .padding(.horizontal, 24)
                    .animation(.easeOut(duration: 0.4), value: viewModel.renderedImage != nil)

                    // ── Opslagstatus ──────────────────────────────
                    Group {
                        if viewModel.isSaving {
                            HStack(spacing: 8) {
                                ProgressView().tint(.white)
                                Text("Opslaan naar Fotobibliotheek…")
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                            }
                        } else if viewModel.autoSaveCompleted {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Automatisch opgeslagen!")
                            }
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.autoSaveCompleted)

                    // ── Actieknoppen ──────────────────────────────
                    VStack(spacing: 12) {

                        // Delen
                        Button(action: viewModel.share) {
                            HStack(spacing: 10) {
                                if viewModel.isPreparingShare {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                Text(viewModel.isPreparingShare ? "Momentje…" : "Deel de fotostrip")
                            }
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color("BirthdayGold").opacity(viewModel.isPreparingShare ? 0.7 : 1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color("BirthdayGold").opacity(0.4), radius: 8, y: 4)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isPreparingShare)
                        }
                        .disabled(viewModel.renderedImage == nil || viewModel.isPreparingShare)

                        // Opnieuw
                        Button(action: viewModel.discard) {
                            HStack(spacing: 10) {
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
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $viewModel.showShareSheet, onDismiss: viewModel.onShareDismissed) {
            if let url = viewModel.shareURL {
                ShareSheet(activityItems: [url])
            }
        }
        .alert("Opslaan mislukt", isPresented: Binding(
            get: { viewModel.saveError != nil },
            set: { if !$0 { viewModel.saveError = nil } }
        )) {
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
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
