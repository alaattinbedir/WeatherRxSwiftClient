//
//  WeatherVC.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 26.11.2021.
//

import Foundation
import UIKit
import CoreLocation
import MLBase
import RxSwift
import RxCocoa

class WeatherVC: BaseVC<WeatherVM> {
    
    // MARK: - Vars & Lets
    
    let locationManager = CLLocationManager()
    let hourlyCellNibName = "HourlyCollectionViewCell"
    let hourlyCellIdentifier = "HourlyCollectionViewCell"
    let dailyCellNibName = "DailyTableViewCell"
    let dailyCellIdentifier = "DailyTableViewCell"
    let minimumInteritemSpacing: CGFloat = 1
    let minimumLineSpacing: CGFloat = 1
    let collectionViewEdgeInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    var sunRiseHour: Int = 7
    var sunSetHour: Int = 19

    // MARK: - Outlets
    
    @IBOutlet weak var cityNameLabel: UILabel! {
        didSet {
            viewModel.cityName.bind(to: cityNameLabel.rx.text).disposed(by: viewModel.disposeBag)        }
    }
    
    @IBOutlet weak var weatherTypeLabel: UILabel! {
        didSet {
            viewModel.weatherType
                .asDriver(onErrorJustReturn: nil)
                .drive(weatherTypeLabel.rx.text)
                .disposed(by: viewModel.disposeBag)
        }
    }
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var currentCityTempLabel: UILabel! {
        didSet {
            viewModel.currentCityTemp
                .map{ Utilities.sharedInstance.convertFahrenheitToCelsius(fahrenheit:$0 ?? 0.0)}
                .asDriver(onErrorJustReturn: nil)
                .drive(currentCityTempLabel.rx.text)
                .disposed(by: viewModel.disposeBag)
        }
    }
    
    @IBOutlet weak var currentDateLabel: UILabel! {
        didSet {
            viewModel.currentDate
                .map{Utilities.sharedInstance.getFormatedDate(date: Double(($0 ?? 0))) }
                .asDriver(onErrorJustReturn: nil)
                .drive(currentDateLabel.rx.text)
                .disposed(by: viewModel.disposeBag)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: dailyCellNibName, bundle: nil), forCellReuseIdentifier: dailyCellIdentifier)
            
            viewModel.weather
                .observe(on: MainScheduler.instance)
                .flatMap { _ in Observable.just(()) }
                .subscribe(onNext: tableView.reloadData)
                .disposed(by: viewModel.disposeBag)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: hourlyCellNibName, bundle: nil), forCellWithReuseIdentifier: hourlyCellIdentifier)
            
            viewModel.weather
                .observe(on: MainScheduler.instance)
                .flatMap { _ in Observable.just(()) }
                .subscribe(onNext: collectionView.reloadData)
                .disposed(by: viewModel.disposeBag)
        }
    }
    
    @IBOutlet weak var background: UIImageView!
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
        viewModel.fetchCurrentWeather()
    }

    override func onStateChanged(_ state: ViewState) {
        super.onStateChanged(state)
        guard let state = state as? WeatherViewState else { return }
        switch state {
        case .close (let message):
            print(message)
            NavigationRouter.dismiss()
        }
    }
    
}

// MARK: Configure the components

extension WeatherVC {
    func configureItems() {
        changeBackground(defaultBg: false)
        setLocationManager()
    }
    
    func changeBackground(defaultBg: Bool) {
        if let hour = Int(Utilities.sharedInstance.getHourFromDate(date: Date().timeIntervalSince1970)) {
            if hour > sunRiseHour && hour < sunSetHour {
                background.image = UIImage(named: "After Noon")
            } else {
                background.image = UIImage(named: "Night")
            }
        }
    }
    
    func setLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
        
    func setSunriseAndSunset() {
        guard let day = viewModel.weather.value?.daily?.data![0] else { return }
        
        sunRiseHour = Int(Utilities.sharedInstance.getHourFromDate(date: Double(day.time!))) ?? sunRiseHour
        sunSetHour = Int(Utilities.sharedInstance.getHourFromDate(date: Double(day.time!))) ?? sunSetHour
    }
}


// MARK: - TableView DataSource and Delegate

extension WeatherVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecastDaily = viewModel.weather.value?.daily?.data else { return 0 }
        
        return forecastDaily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dailyCellIdentifier) as! DailyTableViewCell
        
        guard let data = viewModel.weather.value?.daily?.data![indexPath.row] else { return cell }
        cell.configureCell(dailyData: data)
        
        return cell
    }
}

// MARK: - CollectionView DataSource and Delegate

extension WeatherVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecastHourly = viewModel.weather.value?.hourly?.data else { return 0 }
        
        return forecastHourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyCellIdentifier, for: indexPath) as! HourlyCollectionViewCell
        
        guard let data = viewModel.weather.value?.hourly?.data![indexPath.row] else { return cell }
        cell.configureCell(hourlyData: data)
        
        return cell
    }
}

// MARK: - CollectionView Flowlayout

extension WeatherVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewEdgeInset
    }
}


// MARK: - Location Manager Delegate

extension WeatherVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        viewModel.currentLocation.latitude = locValue.latitude
        viewModel.currentLocation.longitude = locValue.longitude
    }
}
