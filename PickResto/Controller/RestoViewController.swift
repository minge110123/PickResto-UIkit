import UIKit

class RestoViewController: UIViewController, UIScrollViewDelegate {

    var restaurant: Restaurant!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var access: UILabel!
    @IBOutlet weak var open: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(restaurant ?? "nil")
        
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        if let restaurant = restaurant {
            name.text = restaurant.name
            
            
            activityIndicator.startAnimating()
            downloadImage(from: restaurant.photos.mobile.l)
            
            address.text = restaurant.address
            
            access.text = restaurant.access
            
            open.text = restaurant.open
            
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                
                self.photo.image = UIImage(data: data)
                
        
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
