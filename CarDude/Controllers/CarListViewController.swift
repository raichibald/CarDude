//
//  ViewController.swift
//  CarDude
//
//  Created by Raitis Saripo on 16/03/2021.
//

import UIKit
import Alamofire
import DropDown
import CoreLocation

class CarListViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var carListTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    let carManager = CarManager()
    let locationManager = CLLocationManager()
    
    var userLocation: CLLocation?
    var carLocation: CLLocation?
    
    var distanceToCar: Int?
    var sortedDistance: Int?
    
    var car: Car?
    var carsToSort = [Car]()
    var sortedCars: [Car] = [Car]()
    var cars = [CarModelData]()
    
    var filteredData: [CarModelData] = []
    
    var filterByDistance = false
    var isSearching = false
    
    let filterMenu: DropDown = {
        let filterMenu = DropDown()
        filterMenu.dataSource = [
            "Sort By Distance: Nearest First",
            "Sort By Distance: Furthest First"
        ]
        
        let filterIcons = [
            "ascending",
            "descending"
        ]
        
        filterMenu.cellNib = UINib(nibName: "FilterCell", bundle: nil)
        filterMenu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? FilterCell else {
                return
            }
            
            cell.filterImageView.image = UIImage(named: filterIcons[index])
            filterMenu.deselectRow(at: index)
        }
        
        filterMenu.direction = .bottom
        filterMenu.width = 300
        filterMenu.bottomOffset = CGPoint(x: -250, y: 49)

        return filterMenu
    }()
    
    func sortCarsByDistance(by index: Int, with title: String) {
        
        navBar.title = title
        if index == 0 {
            //Nearest distance first
            sortedCars = carsToSort.sorted { $0.distance < $1.distance }
        } else if index == 1 {
            //Furthest distance first
            sortedCars = carsToSort.sorted { $0.distance > $1.distance }
        }
        
        carListTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates and data sources
        searchBar.delegate = self
        
        carListTableView.delegate = self
        carListTableView.dataSource = self
    
        //Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Data from API
        carManager.fetchData { (viewModelData) in
            self.cars = viewModelData
            
            DispatchQueue.main.async {
                DropDown.appearance().cornerRadius = 10
                self.carListTableView.reloadData()
            }
        }
        
        //Filter DropDown Menu
        filterMenu.anchorView = filterButton
        filterMenu.selectionAction = { (index, title) in
            self.sortCarsByDistance(by: index, with: title)
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        filterByDistance = true
        filterMenu.show()
    }
    
    func getCarData(from array: [CarModelData]) {
        for element in array {
            if let lat = element.location?.latitude, let lon = element.location?.longitude {
                let sortedCarLocation = CLLocation(latitude: lat, longitude: lon)
                
                sortedDistance = Int(sortedCarLocation.distance(from: userLocation ?? CLLocation(latitude: 0, longitude: 0)))
                
                self.car = Car(brand: element.model?.title, image: element.model?.photoUrl, number: element.plateNumber, distance: sortedDistance ?? 0, battery: element.batteryPercentage)
                
                
            }
            self.carsToSort.append(self.car!)
            
        }
    }
    
    func getSortedCars() {
        if filteredData.count > 0 {
            getCarData(from: self.filteredData)
        } else {
            getCarData(from: self.cars)
        }
        
    }
}

//MARK: - UITableView DataSource And Delegate Methods

extension CarListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        carsToSort = []
        getSortedCars()
        
        if filterByDistance {
            return sortedCars.count
        } else if isSearching {
            print(filteredData)
            return filteredData.count
        } else {
            return cars.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let carCell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
        
        if let lat = cars[indexPath.row].location?.latitude, let lon = cars[indexPath.row].location?.longitude {
            carLocation = CLLocation(latitude: lat, longitude: lon)
            
            distanceToCar = Int(carLocation!.distance(from: userLocation ?? CLLocation(latitude: 0, longitude: 0)))

            if let distance = distanceToCar {
                carCell.carDistanceLabel.text = "\(distance) km"
            }
        }
        
        if filterByDistance {
            carCell.loadSortedCar(car: sortedCars[indexPath.row])
        } else if isSearching {
            carCell.loadCar(car: filteredData[indexPath.row])
        } else {
            carCell.loadCar(car: cars[indexPath.row])
        }

        return carCell
    }
    
    
}

//MARK: - CLLocationManagerDelegate Methods

extension CarListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            let latitude = currentLocation.coordinate.latitude
            let longtitude = currentLocation.coordinate.longitude
            
            userLocation = CLLocation(latitude: latitude, longitude: longtitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

//MARK: - SearchBar Methods
extension CarListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = true
        
        if filterControl.selectedSegmentIndex == 0 {
            filteredData = cars.filter { ($0.plateNumber?.contains(searchBar.text!))! }
        } else {
            filteredData = cars.filter { (String($0.batteryPercentage ?? 0).contains(searchBar.text!)) }
        }
        
        searchBar.endEditing(true)
        carListTableView.reloadData()
    }
    
    func loadData() {
        filteredData = cars
        carListTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadData()

                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    
                }

            }
        }
    }
}
