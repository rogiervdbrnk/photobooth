import SwiftUI

struct ShotSelectionView: View {
    @State var viewModel: ShotSelectionViewModel

    var body: some View {
        ZStack {
            // Achtergrond
            LinearGradient(
                colors: [Color("BirthdayPink"), Color("BirthdayPurple")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Confetti
            ConfettiPatternView().ignoresSafeArea()

            VStack(spacing: 32) {

                // ── Titel ────────────────────────────────────────
                VStack(spacing: 8) {
                    Text("Photostrip")
                        .font(.system(size: 46, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color("BirthdayGold"))
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                }
                .padding(.top, 60)

                // ── Strip-tekst ──────────────────────────────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tekst op de fotostrip")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)

                    TextField("bijv. 🎉 Loïs is 13 jaar! 🎉", text: $viewModel.stripText)
                        .font(.body)
                        .foregroundStyle(.white)
                        .tint(Color("BirthdayGold"))
                        .padding(14)
                        .background(.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.white.opacity(0.25), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)

                // ── Shot-keuze ───────────────────────────────────
                VStack(spacing: 16) {
                    Text("Hoeveel foto's wil je maken?")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)

                    ForEach(ShotConfiguration.allCases) { config in
                        ShotOptionCard(
                            config: config,
                            isSelected: viewModel.selectedConfiguration == config
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.selectedConfiguration = config
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // ── Doorgaan-knop ────────────────────────────────
                Button(action: viewModel.confirm) {
                    HStack(spacing: 12) {
                        Text("Start de photostrip!")
                            .font(.title3.weight(.bold))
                        Image(systemName: "camera.fill")
                            .font(.title3)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color("BirthdayGold"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color("BirthdayGold").opacity(0.5), radius: 8, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .alert("Toestemming vereist", isPresented: $viewModel.showPermissionAlert) {
            Button("Open Instellingen") { viewModel.openSettings() }
            Button("Annuleer", role: .cancel) {}
        } message: {
            Text(viewModel.permissionError ?? "")
        }
    }
}

// MARK: - ShotOptionCard

private struct ShotOptionCard: View {
    let config: ShotConfiguration
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Kleine foto-icoontjes
                HStack(spacing: 4) {
                    ForEach(0..<config.rawValue, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isSelected
                                  ? Color("BirthdayGold")
                                  : Color.white.opacity(0.4))
                            .frame(width: 28, height: 36)
                    }
                }
                .frame(width: 100, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text(config.displayName)
                        .font(.headline)
                        .foregroundStyle(isSelected ? Color("BirthdayGold") : .white)
                    Text(config.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color("BirthdayGold") : .white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .white.opacity(0.25) : .white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color("BirthdayGold") : .clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
