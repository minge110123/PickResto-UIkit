import Foundation
import UIKit

class RestaurantsTableViewController: UITableViewController {
    
    
    
    @IBAction  func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func exit(_ sender: Any){
        
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
    }
    

    
    @IBOutlet weak var random: UIButton!
    @IBAction func random(_ sender: Any) {
        if restaurants.count > 1 {
            let randomIndex = Int.random(in: 0..<restaurants.count)
            let restaurantToKeep = restaurants[randomIndex]
            restaurants = [restaurantToKeep]
            tableView.reloadData()
        }
    }
    
    var restaurants: [Restaurant] = []
    
    var urlToFetch: URL?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
                
        
               tableView.dataSource = self
               tableView.delegate = self
        
        if let url = urlToFetch {
            Task.init {
                await fetchData(url: url)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = urlToFetch {
            Task.init {
                await fetchData(url: url)
            }
        }
    }
        
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    
    func refreshUI() {
        if restaurants.isEmpty {
            random.setTitle("条件に合致するものが見つかりませんでした", for: .normal)
            random.isEnabled = false
        } else {
            random.setTitle("Pick", for: .normal)
        }
    }

  
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
            
            let restaurant = restaurants[indexPath.row]
            
            if let imageUrl = URL(string: "\(restaurant.logoImage)") {
                cell.loadImage(from: imageUrl)
            }
            
            cell.nameLabel.text = restaurant.name
            cell.descriptionLabel.text = restaurant.genre.point
            
            return cell
        }
        
        func fetchData(url: URL) async {
            print("Fetching data from URL: \(url)")
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self.restaurants = response.results.shop
                    self.tableView.reloadData()
                    self.refreshUI()
                }
            } catch {
                print("Error fetching or decoding JSON: \(error)")
            }
        }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            restaurants.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRestaurant = restaurants[indexPath.row]
        
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "RestoViewController") as! RestoViewController
            detailVC.restaurant = selectedRestaurant
        
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    

        
    }

