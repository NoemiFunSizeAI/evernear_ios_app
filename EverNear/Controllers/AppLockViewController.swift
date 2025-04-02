import UIKit

class AppLockViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.shield")
        imageView.tintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unlockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Unlock with Face ID", for: .normal)
        button.setImage(UIImage(systemName: "faceid"), for: .normal)
        button.backgroundColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let privacyManager = PrivacyManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Automatically attempt authentication when view appears
        authenticateUser()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(unlockButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            unlockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unlockButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            unlockButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            unlockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            unlockButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Update button text based on biometric type
        updateUnlockButtonText()
    }
    
    private func setupActions() {
        unlockButton.addTarget(self, action: #selector(unlockButtonTapped), for: .touchUpInside)
    }
    
    private func updateUnlockButtonText() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                unlockButton.setTitle("Unlock with Face ID", for: .normal)
                unlockButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            case .touchID:
                unlockButton.setTitle("Unlock with Touch ID", for: .normal)
                unlockButton.setImage(UIImage(systemName: "touchid"), for: .normal)
            default:
                unlockButton.setTitle("Unlock", for: .normal)
                unlockButton.setImage(nil, for: .normal)
            }
        } else {
            unlockButton.setTitle("Unlock", for: .normal)
            unlockButton.setImage(nil, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @objc private func unlockButtonTapped() {
        authenticateUser()
    }
    
    private func authenticateUser() {
        privacyManager.authenticateUser { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.unlockApp()
                } else if let error = error {
                    self?.showAlert(message: "Authentication failed: \(error)")
                }
            }
        }
    }
    
    private func unlockApp() {
        privacyManager.unlockApp()
        
        // Dismiss this view controller to reveal the app
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "EverNear", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - Mock Local Authentication

class LAContext {
    enum BiometryType {
        case none
        case touchID
        case faceID
    }
    
    var biometryType: BiometryType {
        // In a real app, this would return the actual biometry type
        // For demo purposes, we'll simulate Face ID
        return .faceID
    }
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        // In a real app, this would check if biometric authentication is available
        return true
    }
    
    func evaluatePolicy(_ policy: LAPolicy, localizedReason reason: String, reply: @escaping (Bool, Error?) -> Void) {
        // In a real app, this would prompt for biometric authentication
        // For demo purposes, we'll simulate success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            reply(true, nil)
        }
    }
}
