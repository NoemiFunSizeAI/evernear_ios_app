import UIKit

class PrivacySettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy & Security"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let biometricAuthLabel: UILabel = {
        let label = UILabel()
        label.text = "Require Biometric Authentication"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let biometricAuthSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let biometricAuthDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Use Face ID or Touch ID to unlock the app"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let screenshotProtectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Prevent Screenshots"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let screenshotProtectionSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let screenshotProtectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Block screenshots to protect your private memories"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let autoLockLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto-Lock App"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let autoLockSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let autoLockDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Automatically lock the app after a period of inactivity"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let autoLockTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto-Lock Time"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let autoLockTimeSegmentedControl: UISegmentedControl = {
        let items = ["1 min", "5 min", "15 min", "30 min"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 1 // Default to 5 minutes
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let dataCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow Anonymous Data Collection"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dataCollectionSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let dataCollectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Help improve EverNear by sharing anonymous usage data"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cloudBackupLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Cloud Backup"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cloudBackupSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let cloudBackupDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Securely back up your memories to the cloud"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exportDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Export My Data", for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete All My Data", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 235/255, alpha: 1.0) // Light red
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let privacyManager = PrivacyManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadSettings()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Privacy & Security"
        
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
        
        // Add subviews to content view
        contentView.addSubview(titleLabel)
        
        // Biometric Authentication
        contentView.addSubview(biometricAuthLabel)
        contentView.addSubview(biometricAuthSwitch)
        contentView.addSubview(biometricAuthDescriptionLabel)
        
        // Screenshot Protection
        contentView.addSubview(screenshotProtectionLabel)
        contentView.addSubview(screenshotProtectionSwitch)
        contentView.addSubview(screenshotProtectionDescriptionLabel)
        
        // Auto-Lock
        contentView.addSubview(autoLockLabel)
        contentView.addSubview(autoLockSwitch)
        contentView.addSubview(autoLockDescriptionLabel)
        contentView.addSubview(autoLockTimeLabel)
        contentView.addSubview(autoLockTimeSegmentedControl)
        
        // Data Collection
        contentView.addSubview(dataCollectionLabel)
        contentView.addSubview(dataCollectionSwitch)
        contentView.addSubview(dataCollectionDescriptionLabel)
        
        // Cloud Backup
        contentView.addSubview(cloudBackupLabel)
        contentView.addSubview(cloudBackupSwitch)
        contentView.addSubview(cloudBackupDescriptionLabel)
        
        // Data Management
        contentView.addSubview(exportDataButton)
        contentView.addSubview(deleteDataButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Biometric Authentication
            biometricAuthLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            biometricAuthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            biometricAuthSwitch.centerYAnchor.constraint(equalTo: biometricAuthLabel.centerYAnchor),
            biometricAuthSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            biometricAuthDescriptionLabel.topAnchor.constraint(equalTo: biometricAuthLabel.bottomAnchor, constant: 5),
            biometricAuthDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            biometricAuthDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Screenshot Protection
            screenshotProtectionLabel.topAnchor.constraint(equalTo: biometricAuthDescriptionLabel.bottomAnchor, constant: 30),
            screenshotProtectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            screenshotProtectionSwitch.centerYAnchor.constraint(equalTo: screenshotProtectionLabel.centerYAnchor),
            screenshotProtectionSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            screenshotProtectionDescriptionLabel.topAnchor.constraint(equalTo: screenshotProtectionLabel.bottomAnchor, constant: 5),
            screenshotProtectionDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            screenshotProtectionDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Auto-Lock
            autoLockLabel.topAnchor.constraint(equalTo: screenshotProtectionDescriptionLabel.bottomAnchor, constant: 30),
            autoLockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            autoLockSwitch.centerYAnchor.constraint(equalTo: autoLockLabel.centerYAnchor),
            autoLockSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            autoLockDescriptionLabel.topAnchor.constraint(equalTo: autoLockLabel.bottomAnchor, constant: 5),
            autoLockDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            autoLockDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            autoLockTimeLabel.topAnchor.constraint(equalTo: autoLockDescriptionLabel.bottomAnchor, constant: 20),
            autoLockTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            autoLockTimeSegmentedControl.topAnchor.constraint(equalTo: autoLockTimeLabel.bottomAnchor, constant: 10),
            autoLockTimeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            autoLockTimeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Data Collection
            dataCollectionLabel.topAnchor.constraint(equalTo: autoLockTimeSegmentedControl.bottomAnchor, constant: 30),
            dataCollectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dataCollectionSwitch.centerYAnchor.constraint(equalTo: dataCollectionLabel.centerYAnchor),
            dataCollectionSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dataCollectionDescriptionLabel.topAnchor.constraint(equalTo: dataCollectionLabel.bottomAnchor, constant: 5),
            dataCollectionDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dataCollectionDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Cloud Backup
            cloudBackupLabel.topAnchor.constraint(equalTo: dataCollectionDescriptionLabel.bottomAnchor, constant: 30),
            cloudBackupLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            cloudBackupSwitch.centerYAnchor.constraint(equalTo: cloudBackupLabel.centerYAnchor),
            cloudBackupSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            cloudBackupDescriptionLabel.topAnchor.constraint(equalTo: cloudBackupLabel.bottomAnchor, constant: 5),
            cloudBackupDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cloudBackupDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Data Management
            exportDataButton.topAnchor.constraint(equalTo: cloudBackupDescriptionLabel.bottomAnchor, constant: 40),
            exportDataButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exportDataButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            exportDataButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteDataButton.topAnchor.constraint(equalTo: exportDataButton.bottomAnchor, constant: 20),
            deleteDataButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteDataButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteDataButton.heightAnchor.constraint(equalToConstant: 50),
            deleteDataButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupAct<response clipped><NOTE>To save on context only part of this file has been shown to you. You should retry this tool after you have searched inside the file with `grep -n` in order to find the line numbers of what you are looking for.</NOTE>