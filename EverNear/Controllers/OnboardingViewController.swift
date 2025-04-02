import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 215/255, blue: 195/255, alpha: 1.0) // Warm sand color
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a heart symbol
        let heartLabel = UILabel()
        heartLabel.text = "♥"
        heartLabel.font = UIFont.systemFont(ofSize: 50)
        heartLabel.textColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        heartLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(heartLabel)
        
        NSLayoutConstraint.activate([
            heartLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            heartLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "EverNear"
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Keeping cherished moments close to your heart"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to EverNear"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "EverNear provides a private, interactive digital space where you can share memories, emotions, and thoughts about your loved one."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lovedOneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of your loved one"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let relationshipTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your relationship (e.g., spouse, parent, friend)"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Your information is private and secure. We use end-to-end encryption to protect your memories."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.text = "Developed by Noemi Reyes"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add subviews to content view
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(lovedOneTextField)
        contentView.addSubview(relationshipTextField)
        contentView.addSubview(continueButton)
        contentView.addSubview(privacyLabel)
        contentView.addSubview(developerLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            welcomeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            nameTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            nameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lovedOneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            lovedOneTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lovedOneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            lovedOneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            lovedOneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            relationshipTextField.topAnchor.constraint(equalTo: lovedOneTextField.bottomAnchor, constant: 16),
            relationshipTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            relationshipTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            relationshipTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            relationshipTextField.heightAnchor.constraint(equalToConstant: 50),
            
            continueButton.topAnchor.constraint(equalTo: relationshipTextField.bottomAnchor, constant: 40),
            continueButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            privacyLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 30),
            privacyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            privacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            privacyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            developerLabel.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 16),
            developerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            developerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            developerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            developerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupActions() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func continueButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let lovedOne = lovedOneTextField.text, !lovedOne.isEmpty,
              let relationship = relationshipTextField.text, !relationship.isEmpty else {
            showAlert(message: "Please fill in all fields to continue.")
            return
        }
        
        // Save user information
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(lovedOne, forKey: "lovedOneName")
        UserDefaults.standard.set(relationship, forKey: "relationship")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Present the main interface
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.setupMainInterface()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
