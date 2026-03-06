import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            // Zelfde achtergrond als ShotSelectionView
            LinearGradient(
                colors: [Color("BirthdayPink"), Color("BirthdayPurple")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Confetti-patroon
            ConfettiPatternView().ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Photostrip")
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color("BirthdayGold"))
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
            }
        }
    }
}
