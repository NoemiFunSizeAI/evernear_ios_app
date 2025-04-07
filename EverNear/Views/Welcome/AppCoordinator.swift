import SwiftUI

struct AppCoordinator: View {
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if !hasCompletedWelcome {
            WelcomeView(hasCompletedWelcome: $hasCompletedWelcome)
        } else if !hasCompletedOnboarding {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        } else {
            ContentView()
        }
    }
}
