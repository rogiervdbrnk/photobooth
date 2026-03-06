import SwiftUI

/// Toont gekleurde bolletjes die aangeven hoeveel shots al gemaakt zijn.
struct ShotProgressView: View {
    let total: Int
    let taken: Int

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index < taken
                          ? Color("BirthdayGold")
                          : Color.white.opacity(0.4))
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .scaleEffect(index < taken ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3), value: taken)
            }
        }
    }
}
