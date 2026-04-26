import SwiftUI

/// Template voor 2 foto's — dubbele fotostrip (400 × 900 pt).
struct TwoShotTemplateView: View {
    let photos: [UIImage]
    let stripText: String
    let stripBackgroundStyle: StripBackgroundStyle
    let photoFilter: PhotoFilterOption
    let photoFrameStyle: PhotoFrameStyle

    var body: some View {
        let style = TemplateStyleResolver.resolve(stripBackgroundStyle)

        ZStack {
            TemplateStyleResolver.backgroundView(for: stripBackgroundStyle)

            VStack(spacing: 16) {

                // ── Twee foto's met witte rand ───────────────────
                ForEach(0..<2, id: \.self) { index in
                    PhotoSlotView(
                        image: index < photos.count ? photos[index] : nil,
                        size: CGSize(width: 368, height: 368),
                        filter: photoFilter,
                        frameStyle: photoFrameStyle
                    )
                }

                // ── Onderbalk ────────────────────────────────────
                ZStack {
                    style.textPanelBackgroundColor
                    Text(stripText)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(style.textColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .frame(width: 400, height: 100)
                }
                .frame(width: 400, height: 100)
                .overlay(Rectangle().fill(style.borderColor).frame(height: 1), alignment: .top)
            }
            .padding(.vertical, 16)
        }
        .frame(width: 400, height: 900)
    }
}
