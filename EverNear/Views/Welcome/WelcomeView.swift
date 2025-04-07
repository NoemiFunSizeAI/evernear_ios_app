import SwiftUI

struct WelcomeView: View {
    @State private var isAnimating = false
    @Binding var hasCompletedWelcome: Bool
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                LogoView()
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
                
                Text("EverNear")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text("Your AI companion for cherished memories")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        hasCompletedWelcome = true
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
}
