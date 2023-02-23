import UIKit

class ProfileViewController: UIViewController {
    
    private let profileImage = UIImage(named: "Novikova_Profile")
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var nicknameLabel : UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = .ypGrey
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nicknameLabel
    }()
    
    private lazy var textLabel : UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Hello, world!"
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .ypWhite
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var button : UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.didTapButton))
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(textLabel)
        view.addSubview(button)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
        
    }
    @objc
    private func didTapButton() {
        
    }
}
