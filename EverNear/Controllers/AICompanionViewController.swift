import UIKit

class AICompanionViewController: UIViewController {
    
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
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let typingIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        view.layer.cornerRadius = 16
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let typingDotsView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Current conversation
    private var currentConversation: Conversation?
    private var messages: [Message] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        setupTypingIndicator()
        loadOrCreateConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "AI Companion"
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup message input view
        messageInputView.addSubview(messageTextField)
        messageInputView.addSubview(sendButton)
        messageInputView.addSubview(activityIndicator)
        
        // Add typing indicator to table view
        view.addSubview(typingIndicatorView)
        typingIndicatorView.addSubview(typingDotsView)
        
        // Add subviews
        view.addSubview(chatTableView)
        view.addSubview(messageInputView)
        
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
            
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            
            typingIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            typingIndicatorView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor, constant: -8),
            typingIndicatorView.widthAnchor.constraint(equalToConstant: 70),
            typingIndicatorView.heightAnchor.constraint(equalToConstant: 40),
            
            typingDotsView.centerXAnchor.constraint(equalTo: typingIndicatorView.centerXAnchor),
            typingDotsView.centerYAnchor.constraint(equalTo: typingIndicatorView.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        chatTableView.register(AIMessageCell.self, forCellReuseIdentifier: "AIMessageCell")
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
    
    private func setupTypingIndicator() {
        // Create typing dots
        for _ in 0..<3 {
            let dotView = UIView()
            dotView.backgroundColor = .darkGray
            dotView.layer.cornerRadius = 4
            dotView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dotView.widthAnchor.constraint(equalToConstant: 8),
                dotView.heightAnchor.constraint(equalToConstant: 8)
            ])
            
            typingDotsView.addArrangedSubview(dotView)
        }
    }
    
    private func loadOrCreateConversation() {
        // In a real app, this would load the current conversation or create a new one
        currentConversation = CompanionService.shared.getCurrentConversation()
        messages = currentConversation?.messages ?? []
        
        // If no messages, add welcome message
        if messages.isEmpty {
            let welcomeMessage = Message(
                content: "Hello, I'm your EverNear companion. I'm here to listen and support you through your grief journey. How are you feeling today?",
                isUser: false
            )
            messages.append(welcomeMessage)
            currentConversation?.messages.append(welcomeMessage)
            DataManager.shared.saveConversation(currentConversation!)
        }
        
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    // MARK: - Actions
    
    @objc private func sendButtonTapped() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        
        // Disable send button and show activity indicator
        sendButton.isHidden = true
        activityIndicator.startAnimating()
        
        // Add user message
        let userMessage = CompanionService.shared.addUserMessage(text)
        messages.append(userMessage)
        
        // Clear text field
        messageTextField.text = ""
        
        // Update UI
        chatTableView.reloadData()
        scrollToBottom()
        
        // Show typing indicator
        showTypingIndicator(true)
        
        // Generate AI response
        CompanionService.shared.generateCompanionResponse(to: text) { [weak self] aiMessage in
            // Hide typing indicator
            self?.showTypingIndicator(false)
            
            // Add AI message
            self?.messages.append(aiMessage)
            
            // Update UI
            self?.chatTableView.reloadData()
            self?.scrollToBottom()
            
            // Re-enable send button and hide activity indicator
            self?.sendButton.isHidden = false
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    
    private func scrollToBottom() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func showTypingIndicator(_ show: Bool) {
        typingIndicatorView.isHidden = !show
        
        if show {
            // Animate typing dots
            animateTypingDots()
        }
    }
    
    private func animateTypingDots() {
        guard !typingIndicatorView.isHidden else { return }
        
        for (index, dotView) in typingDotsView.arrangedSubviews.enumerated() {
            UIView.animate(withDuration: 0.5, delay: 0.15 * Double(index), options: [.repeat, .autoreverse], animations: {
                dotView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension AICompanionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AIMessageCell", for: indexPath) as! AIMessageCell
        
        let message = messages[indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AICompanionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - AI Message Cell

class AIMessageCell: UITableViewCell {
    
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
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(timestampLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12)
        ])
        
        // Constraints that will change based on message type
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    func configure(with message: Message) {
        messageLabel.text = message.content
        
        // Format timestamp
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timestampLabel.text = formatter.string(from: message.date)
        
        if message.isUser {
            bubbleView.backgroundColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
            messageLabel.textColor = .white
            
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            
            // Position timestamp
            NSLayoutConstraint.activate([
                timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
                timestampLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2)
            ])
            
            // Round corners differently for user messages
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            bubbleView.layer.cornerRadius = 16
        } else {
            bubbleView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
            messageLabel.textColor = .black
            
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            
            // Position timestamp
            NSLayoutConstraint.activate([
                timestampLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
                timestampLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2)
            ])
            
            // Round corners differently for companion messages
            bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
            bubbleView.layer.cornerRadius = 16
        }
    }
}
