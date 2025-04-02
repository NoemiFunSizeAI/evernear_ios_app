import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emotionPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you feeling today?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emotionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let recentMemoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Memories"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let memoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 280, height: 180)
        layout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let createMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Create new memory", for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let reflectionCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/255, green: 191/255, blue: 231/255, alpha: 0.3) // Gentle lavender with opacity
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reflectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Reflection"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reflectionTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Memories are a way to hold onto the things you love, the things you are, the things you never want to lose."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupEmotionButtons()
        updateGreeting()
        updateDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add reflection card subviews
        reflectionCard.addSubview(reflectionTitleLabel)
        reflectionCard.addSubview(reflectionTextLabel)
        
        // Add subviews to content view
        contentView.addSubview(greetingLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(emotionPromptLabel)
        contentView.addSubview(emotionStackView)
        contentView.addSubview(recentMemoriesLabel)
        contentView.addSubview(memoriesCollectionView)
        contentView.addSubview(createMemoryButton)
        contentView.addSubview(reflectionCard)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emotionPromptLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            emotionPromptLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionPromptLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emotionStackView.topAnchor.constraint(equalTo: emotionPromptLabel.bottomAnchor, constant: 15),
            emotionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emotionStackView.heightAnchor.constraint(equalToConstant: 60),
            
            recentMemoriesLabel.topAnchor.constraint(equalTo: emotionStackView.bottomAnchor, constant: 30),
            recentMemoriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentMemoriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            memoriesCollectionView.topAnchor.constraint(equalTo: recentMemoriesLabel.bottomAnchor, constant: 15),
            memoriesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memoriesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            memoriesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            createMemoryButton.topAnchor.constraint(equalTo: memoriesCollectionView.bottomAnchor, constant: 20),
            createMemoryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createMemoryButton.widthAnchor.constraint(equalToConstant: 200),
            createMemoryButton.heightAnchor.constraint(equalToConstant: 40),
            
            reflectionCard.topAnchor.constraint(equalTo: createMemoryButton.bottomAnchor, constant: 30),
            reflectionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reflectionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reflectionCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            reflectionTitleLabel.topAnchor.constraint(equalTo: reflectionCard.topAnchor, constant: 15),
            reflectionTitleLabel.leadingAnchor.constraint(equalTo: reflectionCard.leadingAnchor, constant: 15),
            reflectionTitleLabel.trailingAnchor.constraint(equalTo: reflectionCard.trailingAnchor, constant: -15),
            
            reflectionTextLabel.topAnchor.constraint(equalTo: reflectionTitleLabel.bottomAnchor, constant: 10),
            reflectionTextLabel.leadingAnchor.constraint(equalTo: reflectionCard.leadingAnchor, constant: 15),
            reflectionTextLabel.trailingAnchor.constraint(equalTo: reflectionCard.trailingAnchor, constant: -15),
            reflectionTextLabel.bottomAnchor.constraint(equalTo: reflectionCard.bottomAnchor, constant: -15)
        ])
        
        // Setup actions
        createMemoryButton.addTarget(self, action: #selector(createMemoryTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        memoriesCollectionView.register(MemoryCell.self, forCellWithReuseIdentifier: "MemoryCell")
        memoriesCollectionView.dataSource = self
        memoriesCollectionView.delegate = self
    }
    
    private func setupEmotionButtons() {
        let emotions = ["😔", "😐", "😊", "💭"]
        
        for emotion in emotions {
            let button = UIButton(type: .system)
            button.setTitle(emotion, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
            button.layer.cornerRadius = 25
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
            
            emotionStackView.addArrangedSubview(button)
        }
    }
    
    private func updateGreeting() {
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "Friend"
        
        let hour = Calendar.current.component(.hour, from: Date())
        var greeting = "Good morning"
        
        if hour >= 12 && hour < 17 {
            greeting = "Good afternoon"
        } else if hour >= 17 {
            greeting = "Good evening"
        }
        
        greetingLabel.text = "\(greeting), \(userName)"
    }
    
    private func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    // MARK: - Actions
    
    @objc private func emotionButtonTapped(_ sender: UIButton) {
        guard let emotion = sender.titleLabel?.text else { return }
        
        // Provide different responses based on the emotion
        var message = ""
        
        switch emotion {
        case "😔":
            message = "I understand you're feeling down today. Would you like to talk about it or perhaps recall a comforting memory?"
        case "😐":
            message = "Sometimes neutral days are just what we need. Is there anything specific on your mind today?"
        case "😊":
            message = "I'm glad you're feeling positive today! Would you like to capture a happy memory?"
        case "💭":
            message = "It sounds like you're reflective today. Would you like to explore some memories or record your thoughts?"
        default:
            message = "Thank you for sharing how you're feeling. How can I support you today?"
        }
        
        let alert = UIAlertController(title: "EverNear", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Talk to Companion", style: .default, handler: { _ in
            // Navigate to companion tab
            self.tabBarController?.selectedIndex = 2
        }))
        
        alert.addAction(UIAlertAction(title: "Create Memory", style: .default, handler: { _ in
            self.createMemoryTapped()
        }))
        
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func createMemoryTapped() {
        let createMemoryVC = CreateMemoryViewController()
        navigationController?.pushViewController(createMemoryVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // For demo purposes, return 3 cells
        // In a real app, this would be the count of recent memories
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoryCell", for: indexPath) as! MemoryCell
        
        // Configure cell with demo data
        switch indexPath.item {
        case 0:
            cell.configure(title: "Beach Day", date: "Yesterday", hasImage: true)
        case 1:
            cell.configure(title: "Dad's Recipe", date: "3 days ago", hasImage: false)
        case 2:
            cell.configure(title: "Our Wedding", date: "Last week", hasImage: true)
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // In a real app, this would navigate to the memory detail view
        let memoryDetailVC = MemoryDetailViewController()
        navigationController?.pushViewController(memoryDetailVC, animated: true)
    }
}

// MARK: - Memory Cell

class MemoryCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0) // Medium gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: fr<response clipped><NOTE>To save on context only part of this file has been shown to you. You should retry this tool after you have searched inside the file with `grep -n` in order to find the line numbers of what you are looking for.</NOTE>