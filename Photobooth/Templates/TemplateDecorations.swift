import SwiftUI

/// Genereert een willekeurig confetti-patroon als achtergronddecoratie.
struct ConfettiPatternView: View {

    private struct Dot: Identifiable {
        let id = UUID()
        let x, y, size: CGFloat
        let color: Color
    }

    // Eenmalig aanmaken — niet opnieuw genereren bij elke render
    private let dots: [Dot] = {
        let colors: [Color] = [.pink, .yellow, Color(hex: "#9B59B6"), .mint, .orange, .white]
        return (0..<80).map { _ in
            Dot(
                x:    CGFloat.random(in: 0...400),
                y:    CGFloat.random(in: 0...1300),
                size: CGFloat.random(in: 4...12),
                color: colors.randomElement()!
            )
        }
    }()

    var body: some View {
        Canvas { context, _ in
            for dot in dots {
                let rect = CGRect(x: dot.x, y: dot.y, width: dot.size, height: dot.size)
                context.fill(
                    Ellipse().path(in: rect),
                    with: .color(dot.color.opacity(0.45))
                )
            }
        }
        .allowsHitTesting(false)
    }
}

/// Voegt grote decoratieve emoji-accenten toe aan de achtergrond.
struct StarDecorationView: View {
    var body: some View {
        ZStack {
            Text("⭐️").font(.system(size: 60)).position(x: 30,  y: 80).opacity(0.30)
            Text("🎂").font(.system(size: 50)).position(x: 370, y: 120).opacity(0.25)
            Text("🎈").font(.system(size: 55)).position(x: 20,  y: 700).opacity(0.30)
            Text("✨").font(.system(size: 45)).position(x: 380, y: 900).opacity(0.30)
        }
        .allowsHitTesting(false)
    }
}
