import SwiftUI

/// Template voor 1 foto — brede staande fotostrip (400 × 560 pt).
struct OneShotTemplateView: View {
    let photos: [UIImage]
    let stripText: String

    var body: some View {
        ZStack {
            Color.white

            VStack(spacing: 16) {

                // ── Foto met witte rand ──────────────────────────
                if let photo = photos.first {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 368, height: 412)
                        .clipped()
                } else {
                    placeholderRect(width: 368, height: 412)
                }

                // ── Onderbalk ────────────────────────────────────
                ZStack {
                    Color.white
                    Text(stripText)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .frame(width: 400, height: 100)
                }
                .frame(width: 400, height: 100)
            }
            .padding(.vertical, 16)
        }
        .frame(width: 400, height: 560)
    }
}

// MARK: - Placeholder hulpfunctie

private func placeholderRect(width: CGFloat, height: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: 0)
        .fill(Color(hex: "#E0E0E0"))
        .frame(width: width, height: height)
        .overlay(
            Image(systemName: "camera.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color(hex: "#BDBDBD"))
        )
}
