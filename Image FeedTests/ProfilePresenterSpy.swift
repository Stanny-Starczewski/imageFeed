@testable import ImageFeed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    var didExitCalled: Bool = false
    var clean: Bool = false
    var observe: Bool = false

    var profileService: ImageFeed.ProfileService
    
    func updateProfileDetails(profile: Profile?) {
        view?.configureViews()
    }
    
    func observeAvatarChanges() {
        observe = true
    }
    
    func logout() {
         didExitCalled = true
    }
    
    func cleanServicesData() {
        clean = true
    }
    
    func getUrlForProfileImage() -> URL? {
        return URL(string: "\(APIConstants.baseURL)")
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func makeAlert() -> UIAlertController {
        UIAlertController()
    }
    
    init (profileService: ProfileService ) {
        self.profileService = profileService
    }
}
