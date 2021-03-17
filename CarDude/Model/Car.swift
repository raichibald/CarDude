//
//  Car.swift
//  CarDude
//
//  Created by Raitis Saripo on 16/03/2021.
//

import Foundation

struct CarModelData: Codable {
    let plateNumber: String?
    let model: CarModel?
    let location: CarLocation?
    let batteryPercentage: Int?
    
}

struct CarModel: Codable {
    let title: String?
    let photoUrl: String?
}

struct CarLocation: Codable {
    let latitude: Double?
    let longitude: Double?
}

struct Car: Equatable {
    let brand: String?
    let image: String?
    let number: String?
    let distance: Int
    let battery: Int?
}


