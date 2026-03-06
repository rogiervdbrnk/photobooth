import SwiftUI

/// Template voor 3 foto's — de klassieke photobooth-strip (400 × 1240 pt).
struct ThreeShotTemplateView: View {
    let photos: [UIImage]
    let stripText: String

    var body: some View {
        ZStack {
            Color.white

            VStack(spacing: 16) {

                // ── Drie foto's met witte rand ────────────────────────────
                ForEach(0..<3, id: \.self) { index in
                    if index < photos.count {
                        Image(uiImage: photos[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 368, height: 353)
                            .clipped()
                    } else {
                        placeholderRect(width: 368, height: 353)
                    }
                }

                // ── Onderbalk ────────────────────────────────────────────
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
        .frame(width: 400, height: 1240)
    }
}

private func placeholderRect(width: CGFloat, height: CGFloat) -> some View {
    Color(hex: "#E0E0E0")
        .frame(width: width, height: height)
        .overlay(
            Image(systemName: "camera.fill")
                .font(.system(size: 36))
                .foregroundStyle(Color(hex: "#BDBDBD"))
        )
}
