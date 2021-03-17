//
//  CarCell.swift
//  CarDude
//
//  Created by Raitis Saripo on 16/03/2021.
//

import UIKit
import Kingfisher
import CoreLocation


class CarCell: UITableViewCell {

    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var carPlateNumberLabel: UILabel!
    
    @IBOutlet weak var carDistanceLabel: UILabel!
    @IBOutlet weak var carBatteryLabel: UILabel!
    
    @IBOutlet weak var carNameLabel: UILabel!
    func loadCar(car: CarModelData) {
        
        carNameLabel.text = car.model?.title
        carPlateNumberLabel.text = car.plateNumber

        if let battery = car.batteryPercentage {
            carBatteryLabel.text = String(battery)
        }

        if let carImage = car.model?.photoUrl {
            //Read permission problems??
            carImageView.kf.setImage(with: URL(string: carImage))
        }
    }
    
    func loadSortedCar(car: Car) {
        
        carNameLabel.text = car.brand
        carPlateNumberLabel.text = car.number

        if let battery = car.battery {
            carBatteryLabel.text = String(battery)
        }
        
        carDistanceLabel.text = "\(car.distance) km"
        
        if let carImage = car.image {
            carImageView.kf.setImage(with: URL(string: carImage))
        }
    }
}
