import UIKit
import Kingfisher
import WebKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetails(profile: Profile?)
    func observeAvatarChanges()
    func makeAlert() -> UIAlertController
    func logout()
    func cleanServicesData()
    func getUrlForProfileImage() -> URL?
    var profileService: ProfileService { get }
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let webViewViewController = WebViewViewController()
    private let storageToken = OAuth2TokenStorage()
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        updateProfileDetails(profile: profileService.profile)
        observeAvatarChanges()
    }
    
    // MARK: - Update Profile data
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else { return }
        view?.nameLabel.text = profile.name
        view?.nicknameLabel.text = profile.loginName
        view?.textLabel.text = profile.bio
        view?.configureViews()
        view?.configureConstraints()
    }
        
    // MARK: - Notification
    func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
    }
    // MARK: - Alert
    func makeAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            logout()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        alert.dismiss(animated: true)
        return alert
    }
    
    // MARK: - Exit
    func logout() {
        storageToken.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                    .instantiateViewController(withIdentifier: "TabBarViewController")
        tabBarController.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
    
    // MARK: - Profile Image URL
    func getUrlForProfileImage() -> URL? {
        guard  let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL)  else { return nil }
        return url
    }
}
