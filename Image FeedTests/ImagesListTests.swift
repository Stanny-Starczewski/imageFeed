@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let imageListService = ImagesListService()
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testSetLike () {
        //given
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.setLike()
        
        //then
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable1() {
        //given
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        //then
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}
