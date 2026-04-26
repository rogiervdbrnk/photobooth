import SwiftUI

/// Rendert een enkele foto met optioneel filter en decoratieve frame-stijl.
struct PhotoSlotView: View {
    let image: UIImage?
    let size: CGSize
    let filter: PhotoFilterOption
    let frameStyle: PhotoFrameStyle

    private let filterService = PhotoFilterService()

    var body: some View {
        ZStack {
            frameBackground

            content
                .padding(contentPadding)

            frameOverlay
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var content: some View {
        Group {
            if let displayImage {
                Image(uiImage: displayImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(
            width: size.width - (contentPadding * 2),
            height: size.height - (contentPadding * 2)
        )
        .clipped()
    }

    private var displayImage: UIImage? {
        guard let image else { return nil }
        return filterService.applyFilter(filter, to: image)
    }

    @ViewBuilder
    private var frameBackground: some View {
        switch frameStyle {
        case .none:
            Color.clear
        case .confetti:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(hex: "#FFF7FB"))
        case .balloons:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(hex: "#F1E7FF"))
        case .stars:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(hex: "#2D0A4E"))
        case .disco:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(hex: "#EFE8FF"))
        }
    }

    @ViewBuilder
    private var frameOverlay: some View {
        switch frameStyle {
        case .none:
            EmptyView()
        case .confetti:
            ConfettiFrameOverlay()
        case .balloons:
            BalloonCornerOverlay()
        case .stars:
            StarGlamOverlay()
        case .disco:
            DiscoTapeOverlay()
        }
    }

    private var contentPadding: CGFloat {
        switch frameStyle {
        case .none:
            return 0
        case .confetti:
            return 12
        case .balloons:
            return 14
        case .stars:
            return 12
        case .disco:
            return 14
        }
    }

    private var cornerRadius: CGFloat {
        switch frameStyle {
        case .none:
            return 0
        default:
            return 18
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color(hex: "#E0E0E0"))
            .overlay(
                Image(systemName: "camera.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color(hex: "#BDBDBD"))
            )
    }
}

private struct ConfettiFrameOverlay: View {
    var body: some View {
        ZStack {
            cornerConfetti(x: 18, y: 18)
            cornerConfetti(x: 18, y: -18)
            cornerConfetti(x: -18, y: 18)
            cornerConfetti(x: -18, y: -18)
        }
    }

    private func cornerConfetti(x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(Color(hex: "#FF6B9D"))
            .frame(width: 8, height: 8)
            .overlay(Circle().fill(Color(hex: "#FFD700")).frame(width: 5, height: 5).offset(x: 8, y: 6))
            .overlay(Circle().fill(Color(hex: "#9B59B6")).frame(width: 6, height: 6).offset(x: -5, y: 10))
            .offset(x: x, y: y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignmentForOffset(x: x, y: y))
    }

    private func alignmentForOffset(x: CGFloat, y: CGFloat) -> Alignment {
        switch (x >= 0, y >= 0) {
        case (true, true): return .topLeading
        case (true, false): return .bottomLeading
        case (false, true): return .topTrailing
        case (false, false): return .bottomTrailing
        }
    }
}

private struct BalloonCornerOverlay: View {
    var body: some View {
        ZStack {
            Text("🎈")
                .font(.system(size: 28))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Text("🎉")
                .font(.system(size: 24))
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .allowsHitTesting(false)
    }
}

private struct StarGlamOverlay: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(Color.white.opacity(0.35), lineWidth: 2)
            .overlay(
                ZStack {
                    Text("✨")
                        .font(.system(size: 22))
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    Text("⭐️")
                        .font(.system(size: 18))
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            )
    }
}

private struct DiscoTapeOverlay: View {
    var body: some View {
        ZStack {
            tape(width: 28, height: 10, rotation: -20)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            tape(width: 24, height: 10, rotation: 18)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            tape(width: 26, height: 10, rotation: -12)
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .overlay(
            Circle()
                .fill(Color.white.opacity(0.35))
                .frame(width: 6, height: 6)
                .offset(x: -18, y: 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        )
    }

    private func tape(width: CGFloat, height: CGFloat, rotation: Double) -> some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(Color.white.opacity(0.72))
            .frame(width: width, height: height)
            .rotationEffect(.degrees(rotation))
    }
}