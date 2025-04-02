import Foundation

// Mock Message struct
struct Message {
    let content: String
    let isUser: Bool
}

// Test messages
let messages = [
    Message(content: "Hello, I'm struggling with the loss of my mother.", isUser: true),
    Message(content: "I understand this must be incredibly difficult for you. Would you like to tell me more about your mother?", isUser: false),
    Message(content: "She was always there for me. I miss her cooking and our Sunday talks.", isUser: true)
]

// API request
let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? ""
let model = "gemini-pro"
let baseURL = "https://generativelanguage.googleapis.com/v1/models"

let url = URL(string: "\(baseURL)/\(model):generateContent?key=\(apiKey)")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

// Prepare contents for API
var contents: [[String: Any]] = []

// System message
contents.append([
    "role": "model",
    "parts": [[
        "text": """
        You are EverNear, an empathetic AI companion designed to support people through their grief journey.
        Be compassionate, understanding, and reference previous parts of the conversation when appropriate.
        """
    ]]
])

// Add conversation history
for message in messages {
    contents.append([
        "role": message.isUser ? "user" : "model",
        "parts": [[
            "text": message.content
        ]]
    ])
}

// Add current message
contents.append([
    "role": "user",
    "parts": [[
        "text": "I feel so alone without her."
    ]]
])

// Request body
let requestBody: [String: Any] = [
    "contents": contents,
    "generationConfig": [
        "temperature": 0.7,
        "maxOutputTokens": 150
    ]
]

request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody)

// Make request
print("Testing AI response...")
print("Context:")
messages.forEach { message in
    print("\(message.isUser ? "User" : "AI"): \(message.content)")
}
print("\nUser: I feel so alone without her.")
print("\nGenerating response...")

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        print("Error: \(error)")
        exit(1)
    }
    
    if let data = data,
       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
       let candidates = json["candidates"] as? [[String: Any]],
       let content = candidates.first?["content"] as? [String: Any],
       let parts = content["parts"] as? [[String: Any]],
       let text = parts.first?["text"] as? String {
        print("\nAI Response:")
        print(text)
    } else {
        print("Error: Invalid response")
        if let data = data, let responseStr = String(data: data, encoding: .utf8) {
            print("Raw response: \(responseStr)")
        }
        exit(1)
    }
    
    exit(0)
}

task.resume()
RunLoop.main.run()
