//
//  LandingWelcomeVC.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 7.06.2022.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import MLBase

class LandingWelcomeVC: BaseVC<BaseVM> {

    @IBOutlet weak var landingWelcomeLabel: UILabel!

    @IBAction func getLandingWelcome2Page(_ sender: Any) {
//        RoutingEnum.weather.navigate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        landingWelcomeLabel.text = "Welcome to Landing Page Hurrraaaa!"
    }
}
