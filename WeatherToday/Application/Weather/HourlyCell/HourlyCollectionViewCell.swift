//
//  HourlyCollectionViewCell.swift
//  WeatherTodayApp
//
//  Created by mac on 2.09.2019.
//  Copyright © 2019 Alaattin Bedir. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    @IBOutlet weak var tempratureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(hourlyData: ResponseData) {
        
        if let time = hourlyData.time {
            self.hourLabel.text = Utilities.sharedInstance.getHourFromDate(date: Double(time))
        }
        
        if let tempHigh = hourlyData.temperature {
            self.tempratureLabel.text = Utilities.sharedInstance.convertFahrenheitToCelsius(fahrenheit: tempHigh)
        }else {
            self.tempratureLabel.text = Utilities.sharedInstance.convertFahrenheitToCelsius(fahrenheit: 32.0)
        }
        
    }

}
