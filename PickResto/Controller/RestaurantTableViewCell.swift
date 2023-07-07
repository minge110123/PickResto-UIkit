//
//  RestoListCell.swift
//  PickResto
//
//  Created by ZML on 2023/07/05.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
  


    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.restaurantImageView.image = image
                }
            }
        }.resume()
    }
}

