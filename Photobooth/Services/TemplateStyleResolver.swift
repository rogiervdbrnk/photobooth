import SwiftUI

enum TemplateBackgroundPattern: Equatable {
    case none
    case confetti
    case stars
    case sprinkles
}

struct TemplateStyleDefinition {
    let backgroundColors: [Color]
    let textColor: Color
    let textPanelBackgroundColor: Color
    let photoAreaBackgroundColor: Color
    let borderColor: Color
    let accentColor: Color
    let backgroundPattern: TemplateBackgroundPattern
}

enum TemplateStyleResolver {

    static func resolve(_ style: StripBackgroundStyle) -> TemplateStyleDefinition {
        switch style {
        case .classicWhite:
            return TemplateStyleDefinition(
                backgroundColors: [.white],
                textColor: Color(hex: "#111111"),
                textPanelBackgroundColor: .white,
                photoAreaBackgroundColor: .white,
                borderColor: Color.black.opacity(0.08),
                accentColor: Color(hex: "#FF6B9D"),
                backgroundPattern: .none
            )
        case .pinkParty:
            return TemplateStyleDefinition(
                backgroundColors: [Color(hex: "#FFD1E6"), Color(hex: "#FF8FB8")],
                textColor: Color(hex: "#4A1431"),
                textPanelBackgroundColor: Color.white.opacity(0.82),
                photoAreaBackgroundColor: Color.white,
                borderColor: Color.white.opacity(0.45),
                accentColor: Color(hex: "#FF4F93"),
                backgroundPattern: .confetti
            )
        case .goldConfetti:
            return TemplateStyleDefinition(
                backgroundColors: [Color(hex: "#FFF7E8"), Color(hex: "#FFE6B8")],
                textColor: Color(hex: "#4B3510"),
                textPanelBackgroundColor: Color.white.opacity(0.74),
                photoAreaBackgroundColor: .white,
                borderColor: Color(hex: "#E1C46A"),
                accentColor: Color(hex: "#FFD700"),
                backgroundPattern: .confetti
            )
        case .purpleStars:
            return TemplateStyleDefinition(
                backgroundColors: [Color(hex: "#2A0B45"), Color(hex: "#5B2A86")],
                textColor: .white,
                textPanelBackgroundColor: Color.black.opacity(0.18),
                photoAreaBackgroundColor: .white,
                borderColor: Color.white.opacity(0.25),
                accentColor: Color(hex: "#FFD700"),
                backgroundPattern: .stars
            )
        case .rainbowCake:
            return TemplateStyleDefinition(
                backgroundColors: [
                    Color(hex: "#FF8FB8"),
                    Color(hex: "#FFD166"),
                    Color(hex: "#A8E6CF"),
                    Color(hex: "#8EC5FF"),
                    Color(hex: "#C9A7FF")
                ],
                textColor: Color(hex: "#34214F"),
                textPanelBackgroundColor: Color.white.opacity(0.78),
                photoAreaBackgroundColor: .white,
                borderColor: Color.white.opacity(0.5),
                accentColor: Color(hex: "#FF6B9D"),
                backgroundPattern: .sprinkles
            )
        case .orange:
            return TemplateStyleDefinition(
                backgroundColors: [.orange],
                textColor: Color(hex: "#111111"),
                textPanelBackgroundColor: Color.white.opacity(0.74),
                photoAreaBackgroundColor: .orange,
                borderColor: Color.black.opacity(0.08),
                accentColor: Color(hex: "#FF6B9D"),
                backgroundPattern: .none
            )
        }
    }

    @ViewBuilder
    static func backgroundView(for style: StripBackgroundStyle) -> some View {
        let definition = resolve(style)

        ZStack {
            LinearGradient(
                colors: definition.backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            switch definition.backgroundPattern {
            case .none:
                EmptyView()
            case .confetti:
                ConfettiPatternView()
                    .opacity(0.45)
            case .stars:
                StarDecorationView()
                ConfettiPatternView()
                    .opacity(0.18)
            case .sprinkles:
                SprinklesPatternView()
                    .opacity(0.4)
            }
        }
    }
}
