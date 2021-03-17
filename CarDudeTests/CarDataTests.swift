//
//  CarDataTests.swift
//  CarDudeTests
//
//  Created by Raitis Saripo on 17/03/2021.
//

import XCTest
@testable import CarDude

class CarDataTests: XCTestCase {

    func testValidCarData() {
        let carModel = CarModel(title: "Nissan Leaf", photoUrl: "https://s3-eu-west-1.amazonaws.com/rideshareuploads/uploads/nissanLeaf.jpg")
        
        let carLocation = CarLocation(latitude: 54.65179, longitude: 25.28201)
        
        
        let carModelData = CarModelData(plateNumber: "TEST33", model: carModel, location: carLocation, batteryPercentage: 100)

        
        XCTAssertTrue((carModelData.plateNumber != nil))
        XCTAssertTrue((carModelData.model != nil))
        XCTAssertTrue((carModelData.location != nil))
        XCTAssertTrue((carModelData.batteryPercentage != nil))
        
        XCTAssertEqual("Nissan Leaf", carModel.title)
        
        XCTAssertEqual(carLocation.latitude, carModelData.location?.latitude)
        
        
        
    }

}
