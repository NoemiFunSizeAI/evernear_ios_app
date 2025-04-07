import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Your Journey Matters",
            description: "EverNear provides a safe space for processing grief, whether you're mourning one or multiple loved ones.",
            imageName: "heart.fill"
        ),
        OnboardingPage(
            title: "Preserve Memories",
            description: "Create individual memory spaces for each loved one, keeping their stories and your shared moments alive.",
            imageName: "photo.fill"
        ),
        OnboardingPage(
            title: "AI Companion Support",
            description: "Our AI companion adapts to your unique grief journey, providing personalized support for each relationship.",
            imageName: "person.fill.questionmark"
        ),
        OnboardingPage(
            title: "Track Multiple Journeys",
            description: "Different relationships may be at different stages of grief. We help you navigate each unique path.",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Choose Your Support Level",
            description: "Select a plan that fits your needs, from individual support to family sharing.",
            imageName: "star.fill",
            showsSubscription: true
        )
    ]
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation {
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            hasCompletedOnboarding = true
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let showsSubscription: Bool
    
    init(title: String, description: String, imageName: String, showsSubscription: Bool = false) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.showsSubscription = showsSubscription
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var showingSubscription = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.accentColor)
                .padding(.top, 60)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Spacer()
            
            if page.showsSubscription {
                Button(action: { showingSubscription = true }) {
                    Text("View Subscription Plans")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingSubscription) {
                    SubscriptionView()
                }
            }
        }
    }
}
