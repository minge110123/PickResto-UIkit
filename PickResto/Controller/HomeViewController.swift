import UIKit
import Foundation



class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var rangePicker: UIPickerView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var sortOrderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var asyncImageView: UIImageView!
    

    let rangePickerValues = ["300M", "500M", "1000M", "2000M", "3000M"]
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rangePicker
        rangePicker.dataSource = self
        rangePicker.delegate = self
        locationManager.requestLocation()
        
        if let defaultIndex = rangePickerValues.firstIndex(of: "1000M") {
            rangePicker.selectRow(defaultIndex, inComponent: 0, animated: false)
        }
        
        //keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        
        
        //sortOrderSegmentedControl
        sortOrderSegmentedControl.setTitle("おススメ順", forSegmentAt: 0)
        sortOrderSegmentedControl.setTitle("距離順", forSegmentAt: 1)
        //quantityLabel
        quantityStepper.value = 10
        quantityStepper.stepValue = 1
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
            

        
        // Load image
        if let url = URL(string: "https://webservice.recruit.co.jp/banner/hotpepper-m.gif") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.asyncImageView.image = image
                    }
                }
            }.resume()
        }
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rangePickerValues.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rangePickerValues[row]
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
       
        let rangeIndex = rangePicker.selectedRow(inComponent: 0) + 1
                let order = sortOrderSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1
                let count = Int(quantityStepper.value)
                var url: URL? = nil
                
                if let keyword = locationTextField.text, !keyword.isEmpty {
                    url = createURL(keyword: keyword, range: rangeIndex, count: count, order: order)
                } else {
                    
                    let lat = String(format: "%.3f", locationManager.latitude)
                    let lng = String(format: "%.3f", locationManager.longitude)
                    url = createlocationURL(lat: lat, lng: lng, range: rangeIndex, count: count, order: order)
                }
                
                guard let validURL = url else { return }
                self.performSegue(withIdentifier: "showRestaurants", sender: validURL)
            
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurants" {
            print("Preparing for segue")
            
            if let navigationController = segue.destination as? UINavigationController,
               let restaurantsTableViewController = navigationController.viewControllers.first as? RestaurantsTableViewController {
                let rangeIndex = rangePicker.selectedRow(inComponent: 0) + 1
                let order = sortOrderSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1
                let count = Int(quantityStepper.value)
                var url: URL? = nil
                
                if let keyword = locationTextField.text, !keyword.isEmpty {
                    url = createURL(keyword: keyword, range: rangeIndex, count: count, order: order)
                } else {
                    let lat = String(format: "%.3f", locationManager.latitude)
                    let lng = String(format: "%.3f", locationManager.longitude)
                    url = createlocationURL(lat: lat, lng: lng, range: rangeIndex, count: count, order: order)
                }
                
                guard let validURL = url else { return }
                restaurantsTableViewController.urlToFetch = validURL
            }
        }
    }

    @objc func handleTap() {
        view.endEditing(true)
    }



    
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
        }
    
   
    
    func createURL(keyword:String,range:Int, count: Int,order:Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "webservice.recruit.co.jp"
        urlComponents.path = "/hotpepper/gourmet/v1/"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "6ca6c3fab7e6adaf"),
            URLQueryItem(name: "keyword", value:"\(keyword)"),
            URLQueryItem(name: "range", value:"\(range)"),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "format", value: "json")
        ]
        if order == 0 {
            urlComponents.queryItems?.append(URLQueryItem(name: "order", value: "4"))
        }
        
        return urlComponents.url
    }
    
    func createlocationURL(lat: String, lng: String,range:Int, count: Int,order:Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "webservice.recruit.co.jp"
        urlComponents.path = "/hotpepper/gourmet/v1/"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "6ca6c3fab7e6adaf"),
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lng", value: "\(lng)"),
            URLQueryItem(name: "range", value:"\(range)"),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "format", value: "json")
        ]
        if order == 0 {
            urlComponents.queryItems?.append(URLQueryItem(name: "order", value: "4"))
        }
        
        return urlComponents.url
    }
    


    
}
