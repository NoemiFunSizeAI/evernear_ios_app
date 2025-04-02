import UIKit

class CreateMemoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New Memory"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let memoryTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Memory Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categorySegmentedControl: UISegmentedControl = {
        let categories = MemoryCategory.allCases.map { $0.icon }
        let segmentedControl = UISegmentedControl(items: categories)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = MemoryCategory.allCases[0].rawValue
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let recordAudioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Record Audio", for: .normal)
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Location", for: .normal)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.tintColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moodLabel: UILabel = {
        let label = UILabel()
        label.text = "How did this memory make you feel?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let privacySwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let privacyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep this memory private"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Memory", for: .normal)
        button.backgroundColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Selected images
    private var selectedImages: [UIImage] = []
    private var selectedMood: String?
    private var selectedLocation: String?
    private var audioURL: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Create Memory"
        
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
        
        // Setup mood buttons
        setupMoodButtons()
        
        // Add subviews to content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoryTitleTextField)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categorySegmentedControl)
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(contentTextView)
        contentView.addSubview(addPhotoButton)
        contentView.addSubview(recordAudioButton)
        contentView.addSubview(addLocationButton)
        contentView.addSubview(moodLabel)
        contentView.addSubview(moodStackView)
        contentView.addSubview(privacyLabel)
        contentView.addSubview(privacySwitch)
        contentView.addSubview(privacyDescriptionLabel)
        contentView.addSubview(saveButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            memoryTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            memoryTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memoryTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            memoryTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            categoryLabel.topAnchor.constraint(equalTo: memoryTitleTextField.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categorySegmentedControl.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryNameLabel.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor, constant: 5),
            categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentTextView.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalToConstant: 150),
            
            addPhotoButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            addPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 100),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 40),
            
            recordAudioButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            recordAudioButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recordAudioButton.widthAnchor.constraint(equalToConstant: 120),
            recordAudioButton.heightAnchor.constraint(equalToConstant: 40),
            
            addLocationButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            addLocationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addLocationButton.widthAnchor.constraint(equalToConstant: 120),
            addLocationButton.heightAnchor.constraint(equalToConstant: 40),
            
            moodLabel.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 30),
            moodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moodLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            moodStackView.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 10),
            moodStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moodStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moodStackView.heightAnchor.constraint(equalToConstant: 60),
            
            privacyLabel.topAnchor.constraint(equalTo: moodStackView.bottomAnchor, constant: 30),
            privacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            privacySwitch.centerYAnchor.constraint(equalTo: privacyLabel.centerYAnchor),
            privacySwitch.leadingAnchor.constraint(equalTo: privacyLabel.trailingAnchor, constant: 10),
            
            privacyDescriptionLabel.centerYAnchor.constraint(equalTo: privacyLabel.centerYAnchor),
            privacyDescriptionLabel.leadingAnchor.constraint(equalTo: privacySwitch.trailingAnchor, constant: 10),
            privacyDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupMoodButtons() {
        let moods = ["😊", "😢", "😌", "❤️", "😔"]
        
        for mood in moods {
            let button = UIButton(type: .system)
            button.setTitle(mood, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
            button.layer.cornerRadius = 25
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
            
            moodStackView.addArrangedSubview(button)
        }
    }
    
    private func setupActions() {
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        recordAudioButton.addTarget(self, action: #selector(recordAudioTapped), for: .touchUpInside)
        addLocationButton.addTarget(self, action: #selector(addLocationTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveMemoryTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func categoryChanged() {
        let selectedIndex = categorySegmentedControl.selectedSegmentIndex
        let categories = MemoryCategory.allCases
        
        if selectedIndex >= 0 && selectedIndex < categories.count {
            categoryNameLabel.text = categories[selectedIndex].rawValue
        }
    }
    
    @objc private func addPhotoTapped() {
        // In a real app, this would show the image picker
        let alert = UIAlertController(title: "Add Photo", message: "Choose a photo source", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            // Show camera
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            // Show photo library
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }<response clipped><NOTE>To save on context only part of this file has been shown to you. You should retry this tool after you have searched inside the file with `grep -n` in order to find the line numbers of what you are looking for.</NOTE>