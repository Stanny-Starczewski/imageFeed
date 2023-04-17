@testable import ImageFeed
import UIKit

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var photos: [ImageFeed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.checkCompletedList(indexPath)
    }

    func setLike() {
        presenter?.setLike(photoId: "some", isLike: true)
        {[weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTableViewAnimated() {
    }
}
