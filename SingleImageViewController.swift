import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
