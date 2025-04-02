import UIKit

class MoreViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // Data for the table view
    private let sections: [(title: String, items: [(title: String, icon: String)])] = [
        (
            title: "Account",
            items: [
                (title: "Profile", icon: "person.circle"),
                (title: "Preferences", icon: "gear"),
                (title: "Notifications", icon: "bell")
            ]
        ),
        (
            title: "Support",
            items: [
                (title: "Help & FAQ", icon: "questionmark.circle"),
                (title: "Contact Support", icon: "envelope"),
                (title: "Grief Resources", icon: "heart.text.square")
            ]
        ),
        (
            title: "Privacy & Security",
            items: [
                (title: "Privacy Settings", icon: "lock.shield"),
                (title: "Data & Storage", icon: "externaldrive"),
                (title: "Export Memories", icon: "square.and.arrow.up")
            ]
        ),
        (
            title: "About",
            items: [
                (title: "About EverNear", icon: "info.circle"),
                (title: "Terms of Service", icon: "doc.text"),
                (title: "Privacy Policy", icon: "hand.raised")
            ]
        )
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "More"
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(tableView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add footer with developer credit
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let developerLabel = UILabel()
        developerLabel.text = "Developed by Noemi Reyes"
        developerLabel.font = UIFont.systemFont(ofSize: 14)
        developerLabel.textColor = .darkGray
        developerLabel.textAlignment = .center
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let versionLabel = UILabel()
        versionLabel.text = "Version 1.0"
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textColor = .lightGray
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(developerLabel)
        footerView.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            developerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            developerLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            
            versionLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: developerLabel.bottomAnchor, constant: 5)
        ])
        
        tableView.tableFooterView = footerView
    }
}

// MARK: - UITableViewDataSource

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item.title, iconName: item.icon)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

// MARK: - UITableViewDelegate

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section].items[indexPath.row]
        
        // In a real app, this would navigate to the appropriate screen
        // For now, just show an alert
        let alert = UIAlertController(title: item.title, message: "This feature will be implemented in a future version.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Settings Cell

class SettingsCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 91/255, green: 123/255, blue: 156/255, alpha: 1.0) // Calm blue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with title: String, iconName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
    }
}
