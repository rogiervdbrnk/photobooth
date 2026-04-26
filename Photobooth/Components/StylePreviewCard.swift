import SwiftUI

struct StylePreviewCard<Preview: View>: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let preview: Preview

    init(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void,
        @ViewBuilder preview: () -> Preview
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
        self.preview = preview()
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                preview
                    .frame(width: 72, height: 84)
                    .background(.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(isSelected ? Color("BirthdayGold") : .white.opacity(0.18), lineWidth: isSelected ? 2 : 1)
                    )

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }
        }
        .buttonStyle(.plain)
    }
}