@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol
    
    init (presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var nicknameLabel = UILabel()
    var textLabel = UILabel()
    var update: Bool = false
    var views: Bool = false
    var constraints: Bool = false
    var alert: Bool = false
    
    func updateAvatar() {
        update = true
    }
    
    func configureViews() {
        views = true
    }
    
    func configureConstraints() {
        constraints = true
    }
    
    func showAlert() {
        presenter.logout()
    }
    
    func showLogoutAlert() {
        alert = true
    }
}
