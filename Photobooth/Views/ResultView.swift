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
                VStack(spacing: 18) {

                    Text(String(localized: "result.title"))
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
                                .frame(height: 240)
                        }
                    }
                    .frame(maxHeight: 420)
                    .padding(.horizontal, 24)
                    .animation(.easeOut(duration: 0.4), value: viewModel.renderedImage != nil)

                    // ── Opslagstatus ──────────────────────────────
                    Group {
                        if viewModel.isSaving {
                            HStack(spacing: 8) {
                                ProgressView().tint(.white)
                                Text(String(localized: "result.saving_to_library"))
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                            }
                        } else if viewModel.hasUnsavedChanges {
                            HStack(spacing: 8) {
                                Image(systemName: "wand.and.stars")
                                Text(String(localized: "result.preview_unsaved"))
                            }
                            .foregroundStyle(.white.opacity(0.9))
                            .font(.subheadline)
                        } else if viewModel.hasSavedToPhotoLibrary {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text(String(localized: "result.saved_to_library"))
                            }
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.hasSavedToPhotoLibrary || viewModel.hasUnsavedChanges)

                    editorPanel

                    // ── Actieknoppen ──────────────────────────────
                    VStack(spacing: 12) {

                        Button(action: viewModel.saveCurrentPreview) {
                            HStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.down")
                                Text(String(localized: "result.save_this_version"))
                            }
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white.opacity(0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .disabled(viewModel.renderedImage == nil || viewModel.isSaving || viewModel.isRenderingPreview)

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
                                Text(
                                    viewModel.isPreparingShare
                                    ? String(localized: "result.preparing_share")
                                    : String(localized: "result.share")
                                )
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
                        .disabled(viewModel.renderedImage == nil || viewModel.isPreparingShare || viewModel.isRenderingPreview)

                        // Opnieuw
                        Button(action: viewModel.discard) {
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.counterclockwise")
                                Text(String(localized: "result.start_over"))
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
        .overlay(alignment: .bottom) {
            if viewModel.showSaveConfirmation {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                    Text(String(localized: "result.saved_to_library"))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("BirthdayPurple"))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.18), radius: 10, y: 6)
                .padding(.bottom, 18)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $viewModel.showShareSheet, onDismiss: viewModel.onShareDismissed) {
            if let url = viewModel.shareURL {
                ShareSheet(activityItems: [url])
            }
        }
        .alert(String(localized: "result.save_failed_title"), isPresented: Binding(
            get: { viewModel.saveError != nil },
            set: { if !$0 { viewModel.saveError = nil } }
        )) {
            Button(String(localized: "common.ok")) { viewModel.saveError = nil }
        } message: {
            Text(viewModel.saveError ?? "")
        }
    }

    private var editorPanel: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(String(localized: "result.editor.title"))
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 8) {
                Text(String(localized: "result.editor.strip_text"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.92))

                TextField(
                    String(localized: "result.editor.placeholder"),
                    text: Binding(
                        get: { viewModel.editableStripText },
                        set: { viewModel.updateStripText($0) }
                    )
                )
                .textInputAutocapitalization(.sentences)
                .disableAutocorrection(false)
                .padding(14)
                .background(.white.opacity(0.16))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                )
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)

            pickerSection(title: String(localized: "result.editor.background")) {
                ForEach(StripBackgroundStyle.allCases) { style in
                    StylePreviewCard(
                        title: style.displayName,
                        isSelected: viewModel.selectedBackgroundStyle == style,
                        action: { viewModel.selectBackgroundStyle(style) }
                    ) {
                        ZStack(alignment: .bottom) {
                            TemplateStyleResolver.backgroundView(for: style)

                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.9))
                                    .frame(width: 46, height: 22)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(TemplateStyleResolver.resolve(style).textPanelBackgroundColor)
                                    .frame(width: 46, height: 12)
                            }
                            .padding(.bottom, 8)
                        }
                    }
                }
            }

            pickerSection(title: String(localized: "result.editor.filter")) {
                ForEach(PhotoFilterOption.allCases) { option in
                    OptionChip(
                        title: option.displayName,
                        isSelected: viewModel.selectedFilter == option,
                        action: { viewModel.selectFilter(option) }
                    )
                }
            }

            pickerSection(title: String(localized: "result.editor.photo_frame")) {
                ForEach(PhotoFrameStyle.allCases) { style in
                    StylePreviewCard(
                        title: style.displayName,
                        isSelected: viewModel.selectedPhotoFrameStyle == style,
                        action: { viewModel.selectPhotoFrameStyle(style) }
                    ) {
                        PhotoSlotView(
                            image: nil,
                            size: CGSize(width: 56, height: 56),
                            filter: .original,
                            frameStyle: style
                        )
                        .padding(8)
                    }
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }

    private func pickerSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.92))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    content()
                }
                .padding(.horizontal, 1)
            }
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
