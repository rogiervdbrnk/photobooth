import SwiftUI

struct OptionChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? Color(hex: "#2D0A4E") : .white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color("BirthdayGold") : .white.opacity(0.14))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color("BirthdayGold") : .white.opacity(0.18), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}