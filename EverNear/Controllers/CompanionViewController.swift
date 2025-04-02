import UIKit

class CompanionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let messageInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type your message..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let welcomeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 200/255, green: 191/255, blue: 231/255, alpha: 0.3) // Gentle lavender with opacity
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a message symbol
        let messageLabel = UILabel()
        messageLabel.text = "💬"
        messageLabel.font = UIFont.systemFont(ofSize: 40)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        return imageView
    }()
    
    private let welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your EverNear Companion"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "I'm here to listen, support, and help you preserve memories of your loved one. How can I support you today?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Demo messages for the chat
    private var messages: [(text: String, isUser: Bool)] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        
        // Add initial welcome message from companion
        addCompanionMessage("Hello, I'm your EverNear companion. I'm here to listen and support you through your grief journey. How are you feeling today?")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Companion"
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup message input view
        messageInputView.addSubview(messageTextField)
        messageInputView.addSubview(sendButton)
        
        // Setup welcome view
        welcomeView.addSubview(welcomeImageView)
        welcomeView.addSubview(welcomeTitleLabel)
        welcomeView.addSubview(welcomeDescriptionLabel)
        welcomeView.addSubview(suggestionStackView)
        
        // Add suggestion buttons
        setupSuggestionButtons()
        
        // Add subviews
        view.addSubview(chatTableView)
        view.addSubview(messageInputView)
        view.addSubview(welcomeView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 60),
            
            messageTextField.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 15),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            sendButton.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -15),
            sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            
            welcomeView.centerXAnchor.constraint(equalTo: chatTableView.centerXAnchor),
            welcomeView.centerYAnchor.constraint(equalTo: chatTableView.centerYAnchor, constant: -50),
            welcomeView.leadingAnchor.constraint(equalTo: chatTableView.leadingAnchor, constant: 30),
            welcomeView.trailingAnchor.constraint(equalTo: chatTableView.trailingAnchor, constant: -30),
            
            welcomeImageView.topAnchor.constraint(equalTo: welcomeView.topAnchor),
            welcomeImageView.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            welcomeImageView.widthAnchor.constraint(equalToConstant: 100),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 100),
            
            welcomeTitleLabel.topAnchor.constraint(equalTo: welcomeImageView.bottomAnchor, constant: 20),
            welcomeTitleLabel.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            welcomeTitleLabel.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor),
            welcomeTitleLabel.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor),
            
            welcomeDescriptionLabel.topAnchor.constraint(equalTo: welcomeTitleLabel.bottomAnchor, constant: 10),
            welcomeDescriptionLabel.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            welcomeDescriptionLabel.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor),
            welcomeDescriptionLabel.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor),
            
            suggestionStackView.topAnchor.constraint(equalTo: welcomeDescriptionLabel.bottomAnchor, constant: 20),
            suggestionStackView.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            suggestionStackView.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor),
            suggestionStackView.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor),
            suggestionStackView.bottomAnchor.constraint(equalTo: welcomeView.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        chatTableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.tableFooterView = UIView()
    }
    
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupSuggestionButtons() {
        let suggestions = [
            "I'm feeling sad today",
            "I want to share a memory",
            "How do I cope with grief?",
            "I miss them so much"
        ]
        
        for suggestion in suggestions {
            let button = UIButton(type: .system)
            button.setTitle(suggestion, for: .normal)
            button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
            button.setTitleColor(.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 15
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // Set width constraint to match parent width
            button.widthAnchor.constraint(equalTo: suggestionStackView.widthAnchor, constant: -20).isActive = true
            
            button.addTarget(self, action: #selector(suggestionButtonTapped(_:)), for: .touchUpInside)
            suggestionStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    
    @objc private func sendButtonTapped() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        
        // Add user message
        addUserMessage(text)
        
        // Clear text field
        messageTextField.text = ""
        
        // Hide welcome view when conversation starts
        welcomeView.isHidden = true
        
        // Generate companion response
        generateCompanionResponse(to: text)
    }
    
    @objc private func suggestionButtonTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        // Add user message
        addUserMessage(text)
        
        // Hide welcome view when conversation starts
        welcomeView.isHidden = true
        
        // Generate companion response
        generateCompanionResponse(to: text)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    
    private func addUserMessage(_ text: String) {
        messages.append((text: text, isUser: true))
        
        // Reload table and scroll to bottom
        updateChatView()
    }
    
    private func addCompanionMessage(_ text: String) {
        messages.append((text: text, isUser: false))
        
        // Reload table and scroll to bottom
        updateChatView()
    }
    
    private func updateChatView() {
        chatTableView.reloadData()
        
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func generateCompanionResponse(to userMessage: String) {
        // In a real app, this would call an AI service
        // For demo purposes, we'll use predefined responses
        
        // Simulate typing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let lowercasedMessage = userMessage.lowercased()
            
            if lowercasedMessage.contains("sad") || lowercasedMessage.contains("miss") {
                self.addCompanionMessage("I understand that sadness can feel overwhelming. Would you like to talk about what's bringing up these feelings today?")
            } else if lowercasedMessage.contains("memory") || lowercasedMessage.contains("remember") {
                self.addCompanionMessage("I'd love to hear about that memory. Sharing memories can be a meaningful way to honor your loved one. What would you like to share?")
            } else if lowercasedMessage.contains("cope") || lowercasedMessage.contains("how do i") {
                self.addCompanionMessage("Grief is a unique journey for everyone. Some find comfort in creating rituals, others in talking about their loved ones. What has brought you moments of peace so far?")
            } else {
                self.addCompanionMessage("Thank you for sharing that with me. Would you like to explore this further, or perhaps recall a special memory of your loved one?")
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension CompanionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.configure(with: message.text, isUser: message.isUser)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CompanionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Message Cell

class MessageCell: UITableViewCell {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: <response clipped><NOTE>To save on context only part of this file has been shown to you. You should retry this tool after you have searched inside the file with `grep -n` in order to find the line numbers of what you are looking for.</NOTE>