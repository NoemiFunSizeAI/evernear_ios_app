import UIKit

class MemoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let filterBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filter ▼", for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search 🔍", for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sort ▼", for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0) // Light gray
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 215/255, blue: 195/255, alpha: 0.3) // Warm sand with opacity
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
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No memories yet"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Start capturing memories of your loved one to see them here."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create First Memory", for: .normal)
        button.backgroundColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        
        // For demo purposes, we'll show some memories
        // In a real app, we would check if there are memories and show empty state if needed
        emptyStateView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Memories"
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup filter bar
        filterBar.addArrangedSubview(filterButton)
        filterBar.addArrangedSubview(searchButton)
        filterBar.addArrangedSubview(sortButton)
        
        // Setup empty state view
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateDescriptionLabel)
        emptyStateView.addSubview(createMemoryButton)
        
        // Add subviews
        view.addSubview(filterBar)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            filterBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: filterBar.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            emptyStateDescriptionLabel.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 10),
            emptyStateDescriptionLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateDescriptionLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateDescriptionLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            createMemoryButton.topAnchor.constraint(equalTo: emptyStateDescriptionLabel.bottomAnchor, constant: 30),
            createMemoryButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            createMemoryButton.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            createMemoryButton.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
            createMemoryButton.heightAnchor.constraint(equalToConstant: 50),
            createMemoryButton.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
        
        // Setup actions
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        createMemoryButton.addTarget(self, action: #selector(createMemoryTapped), for: .touchUpInside)
        
        // Add create button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMemoryTapped))
    }
    
    private func setupCollectionView() {
        collectionView.register(MemoryGridCell.self, forCellWithReuseIdentifier: "MemoryGridCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Calculate cell size based on screen width
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (view.frame.width - 60) / 2 // 2 cells per row with 20pt spacing and 20pt padding on each side
            layout.itemSize = CGSize(width: width, height: width * 1.3) // Aspect ratio of approximately 3:4
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped() {
        // In a real app, this would show filter options
        let alert = UIAlertController(title: "Filter Memories", message: "Choose a category to filter by", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "All Memories", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Magical Moments", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Heartfelt Feelings", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Life Updates", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Difficult Times", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Shared Wins", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        // In a real app, this would show search interface
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search memories..."
        present(searchController, animated: true)
    }
    
    @objc private func sortButtonTapped() {
        // In a real app, this would show sort options
        let alert = UIAlertController(title: "Sort Memories", message: "Choose how to sort your memories", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Newest First", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Oldest First", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Alphabetically", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func createMemoryTapped() {
        let createMemoryVC = CreateMemoryViewController()
        navigationController?.pushViewController(createMemoryVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MemoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // For demo purposes, return 6 cells
        // In a real app, this would be the count of memories
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoryGridCell", for: indexPath) as! MemoryGridCell
        
        // Configure cell with demo data
        switch indexPath.item {
        case 0:
            cell.configure(title: "Beach Day", date: "Yesterday", hasImage: true, colorIndex: 0)
        case 1:
            cell.configure(title: "Dad's Recipe", date: "3 days ago", hasImage: false, colorIndex: 1)
        case 2:
            cell.configure(title: "His Laugh", date: "Last week", hasImage: false, colorIndex: 2)
        case 3:
            cell.configure(title: "Our Wedding", date: "2 weeks ago", hasImage: true, colorIndex: 3)
        case 4:
            cell.configure(title: "First Date", date: "Last month", hasImage: true, colorIndex: 4)
        case 5:
            cell.configure(title: "Favorite Song", date: "2 months ago", hasImage: false, colorIndex: 5)
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MemoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // In a real app, this would navigate to the memory detail view
        let memoryDetailVC = MemoryDetailViewController()
        navigationController?.pushViewController(memoryDetailVC, animated: true)
    }
}

// MARK: - Memory Grid Cell

class MemoryGridCell: UICollectionViewCell {
    
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
        super.init(frame: frame)
        setupUI()
  <response clipped><NOTE>To save on context only part of this file has been shown to you. You should retry this tool after you have searched inside the file with `grep -n` in order to find the line numbers of what you are looking for.</NOTE>