import SwiftUI

struct DailyCheckInView: View {
    @StateObject private var viewModel = DailyCheckInViewModel()
    @State private var showingSelfCare = false
    @State private var showingSupport = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text(viewModel.checkInPrompt)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Emotion Selection
                EmotionSelectionView(selectedEmotion: $viewModel.selectedEmotion)
                
                // Intensity Slider
                VStack(alignment: .leading) {
                    Text("How intense is this feeling?")
                        .font(.headline)
                    
                    HStack {
                        Text("Gentle")
                        Slider(value: $viewModel.emotionalIntensity, in: 1...10, step: 1)
                        Text("Intense")
                    }
                }
                .padding()
                
                // Activities
                VStack(alignment: .leading) {
                    Text("What have you been doing today?")
                        .font(.headline)
                    
                    ForEach(viewModel.commonActivities, id: \.self) { activity in
                        CheckboxRow(
                            title: activity,
                            isChecked: viewModel.selectedActivities.contains(activity),
                            action: { viewModel.toggleActivity(activity) }
                        )
                    }
                }
                .padding()
                
                // Notes
                VStack(alignment: .leading) {
                    Text("Any thoughts you'd like to share?")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 100)
                        .border(Color.gray.opacity(0.2))
                }
                .padding()
                
                // Support Options
                VStack(spacing: 15) {
                    Button(action: { showingSelfCare = true }) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Self-Care Suggestions")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: { showingSupport = true }) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                            Text("Support Resources")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
                
                // Submit Button
                Button(action: viewModel.submitCheckIn) {
                    Text("Save Check-In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingSelfCare) {
            SelfCareView(emotion: viewModel.selectedEmotion)
        }
        .sheet(isPresented: $showingSupport) {
            SupportResourcesView(
                emotion: viewModel.selectedEmotion,
                intensity: Int(viewModel.emotionalIntensity)
            )
        }
    }
}

struct EmotionSelectionView: View {
    @Binding var selectedEmotion: String
    
    let emotions = [
        ("deep_grief", "Heart with Tear"),
        ("raw_pain", "Breaking Heart"),
        ("anger", "Fire"),
        ("anxiety", "Spiral"),
        ("numbness", "Cloud"),
        ("hope", "Sun"),
        ("acceptance", "Peace")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("How are you feeling?")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80))
            ], spacing: 20) {
                ForEach(emotions, id: \.0) { emotion in
                    EmotionButton(
                        emotion: emotion.0,
                        icon: emotion.1,
                        isSelected: selectedEmotion == emotion.0,
                        action: { selectedEmotion = emotion.0 }
                    )
                }
            }
        }
        .padding()
    }
}

struct EmotionButton: View {
    let emotion: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(icon)
                    .font(.title)
                Text(emotion.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct CheckboxRow: View {
    let title: String
    let isChecked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
                Text(title)
                Spacer()
            }
        }
    }
}

class DailyCheckInViewModel: ObservableObject {
    @Published var selectedEmotion = ""
    @Published var emotionalIntensity: Double = 5
    @Published var selectedActivities: Set<String> = []
    @Published var notes = ""
    
    private let checkInManager = CheckInManager.shared
    
    var checkInPrompt: String {
        checkInManager.getCheckInPrompt()
    }
    
    let commonActivities = [
        "Looked at photos",
        "Shared memories",
        "Spent time outside",
        "Connected with others",
        "Practiced self-care",
        "Rested",
        "Journaled",
        "Cried",
        "Worked/studied",
        "Other"
    ]
    
    func toggleActivity(_ activity: String) {
        if selectedActivities.contains(activity) {
            selectedActivities.remove(activity)
        } else {
            selectedActivities.insert(activity)
        }
    }
    
    func submitCheckIn() {
        let checkIn = DailyCheckIn(
            date: Date(),
            emotionalState: EmotionalState(
                primaryEmotion: selectedEmotion,
                intensity: Int(emotionalIntensity),
                mixedEmotions: []
            ),
            activities: Array(selectedActivities),
            selfCareActions: [],
            notes: notes,
            supportNeeded: emotionalIntensity > 7
        )
        
        checkInManager.recordCheckIn(checkIn)
        
        // Reset form
        selectedEmotion = ""
        emotionalIntensity = 5
        selectedActivities.removeAll()
        notes = ""
    }
}
