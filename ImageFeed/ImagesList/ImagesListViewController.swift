import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    //private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        imagesListService.fetchPhotosNextPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ImagesListService.DidChangeNotification, object: nil)
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates{
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            guard let imageURL = URL(string: photo.largeImageURL!) else { return }
            //            let image = UIImage(named: photosName[indexPath.row])
            //            viewController.image = image
            viewController.imageURL = imageURL
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
//MARK: - Extensions
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let imageURL = URL(string: photo.thumbImageURL!) else { return }
        
//        let offsetX: CGFloat = 20
//        let offsetY: CGFloat = 3
//        let cornerRadius: CGFloat = cell.cellImage.layer.cornerRadius
//
//        let gradient = AnimationGradientFactory().createGradient(
//            width: cell.frame.width - offsetX * 2,
//            height: cell.frame.height - offsetY * 2,
//            offsetX: offsetX, offsetY: offsetY, cornerRadius: cornerRadius)
//        cell.layer.addSublayer(gradient)
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub")) { _ in
//            gradient.removeFromSuperlayer()
        }
        
        //let date = dateFormatter.date(from: photo.createdAt ?? Date())
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        
        //cell.setIsLiked(isLiked: photo.isLiked)
//        if let urlString = ImagesListService.shared.photos[indexPath.row].thumbImageURL,
//           let imagesURL = URL(string: urlString) {
//            cell.cellImage.kf.indicatorType = .activity
//            cell.cellImage.kf.setImage(with: imagesURL,
//                                       placeholder: UIImage(named: "Stub")) { [weak self] _ in
//                guard let self = self else { return }
//                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//
//            cell.dateLabel.text = dateFormatter.string(from: imagesListService.photos[indexPath.row].createdAt ?? Date())
            
            //            let isLiked = indexPath.row % 2 == 0
            //            let likeImage = isLiked ? UIImage(named: "noActive") : UIImage(named: "YesActive")
            //            cell.likeOrDislakeButton.setImage(likeImage, for: .normal)
        }
        
        //        cell.cellImage.image = image
        //        cell.dateLabel.text = dateFormatter.string(from: Date())
        //
        //        let isLiked = indexPath.row % 2 == 0
        //        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        //        cell.likeButton.setImage(likeImage, for: .normal)
        //        cell.selectionStyle = .none
    }


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageHeight = imagesListService.photos[indexPath.row].size.height
        let imageWidth = imagesListService.photos[indexPath.row].size.width
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    //
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        //imageListCell.delegate = self

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
//    class AnimationGradientFactory {
//        static let shared = AnimationGradientFactory()
//
//        func createGradient(width: CGFloat, height: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat = 0, cornerRadius: CGFloat) -> CAGradientLayer {
//            let gradient = CAGradientLayer()
//            gradient.frame = CGRect(x: CGFloat(.zero + offsetX), y: CGFloat(.zero + offsetY), width: width, height: height)
//            gradient.locations = [0, 0.1, 0.3]
//            gradient.colors = [
//                UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
//                UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
//                UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
//            ]
//            gradient.startPoint = CGPoint(x: 0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 1, y: 0.5)
//            gradient.cornerRadius = cornerRadius
//            gradient.masksToBounds = true
//
//            let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
//            gradientChangeAnimation.duration = 1.0
//            gradientChangeAnimation.repeatCount = .infinity
//            gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
//            gradientChangeAnimation.toValue = [0, 0.8, 1]
//            gradient.add(gradientChangeAnimation, forKey: "locationsChange")
//
//            return gradient
//        }
//    }

}


