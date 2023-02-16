import UIKit

class ProfileViewController: UIViewController {
    private var nameLabel: UILabel?
    private var nicknameLabel: UILabel?
    private var textLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileImage = UIImage(named: "Novikova_Profile")
        let imageView = UIImageView(image: profileImage)
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        self.nameLabel = nameLabel
        
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = .ypGrey
        self.nicknameLabel = nicknameLabel
        
        let textLabel = UILabel()
        textLabel.text = "Hello, world"
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .ypWhite
        self.textLabel = textLabel
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton))
        button.tintColor = .ypRed
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(textLabel)
        view.addSubview(button)
        
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
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        nicknameLabel?.removeFromSuperview()
        nicknameLabel = nil
        textLabel?.removeFromSuperview()
        textLabel = nil
    }
}
