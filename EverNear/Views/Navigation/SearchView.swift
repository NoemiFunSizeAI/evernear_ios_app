import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchQuery)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Search Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SearchFilter.allCases) { filter in
                            FilterChip(
                                filter: filter,
                                isSelected: viewModel.selectedFilters.contains(filter),
                                action: { viewModel.toggleFilter(filter) }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Results
                if viewModel.isSearching {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    SearchResultsList(results: viewModel.searchResults)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search memories, journal entries...", text: $text)
                .textFieldStyle(.plain)
                .focused($isFocused)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .onAppear { isFocused = true }
    }
}

struct FilterChip: View {
    let filter: SearchFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(filter.name)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color(.systemGray6))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct SearchResultsList: View {
    let results: [SearchResult]
    
    var body: some View {
        List {
            ForEach(results) { result in
                SearchResultRow(result: result)
            }
        }
        .listStyle(.plain)
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: result.type.icon)
                    .foregroundColor(result.type.color)
                Text(result.title)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text(result.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            if !result.preview.isEmpty {
                Text(result.preview)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if !result.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(result.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 12))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color(.systemGray6))
                                )
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var selectedFilters: Set<SearchFilter> = []
    @Published var searchResults: [SearchResult] = []
    @Published var isSearching = false
    
    private var searchTask: Task<Void, Never>?
    
    init() {
        // Set up search query observation
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func toggleFilter(_ filter: SearchFilter) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
        performSearch(query: searchQuery)
    }
    
    private func performSearch(query: String) {
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        searchTask = Task {
            // Simulate network delay
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            // Perform search based on query and filters
            let results = await searchContent(query: query, filters: selectedFilters)
            
            await MainActor.run {
                self.searchResults = results
                self.isSearching = false
            }
        }
    }
    
    private func searchContent(query: String, filters: Set<SearchFilter>) async -> [SearchResult] {
        // TODO: Implement actual search logic
        return []
    }
}

enum SearchFilter: String, CaseIterable, Identifiable {
    case memories
    case journal
    case companion
    case voice
    case photos
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .memories: return "Memories"
        case .journal: return "Journal"
        case .companion: return "Companion"
        case .voice: return "Voice"
        case .photos: return "Photos"
        }
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let preview: String
    let date: Date
    let type: SearchResultType
    let tags: [String]
}

enum SearchResultType {
    case memory
    case journal
    case conversation
    case voice
    case photo
    
    var icon: String {
        switch self {
        case .memory: return "heart.fill"
        case .journal: return "book.fill"
        case .conversation: return "bubble.left.fill"
        case .voice: return "waveform"
        case .photo: return "photo.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .memory: return .red
        case .journal: return .blue
        case .conversation: return .green
        case .voice: return .purple
        case .photo: return .orange
        }
    }
}
