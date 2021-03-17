//
//  CarManager.swift
//  CarDude
//
//  Created by Raitis Saripo on 16/03/2021.
//

import Foundation
import Alamofire

struct CarManager {

    let carLibraryURL = "https://development.espark.lt/api/mobile/public/availablecars"
    
    func fetchData(completion: @escaping ([CarModelData]) -> ()) {
        AF.request(carLibraryURL, method: .get).responseDecodable(of: [CarModelData].self) { (response) in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    
}
