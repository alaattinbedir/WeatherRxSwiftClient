//
//  DailyTableViewCell.swift
//  WeatherTodayApp
//
//  Created by mac on 2.09.2019.
//  Copyright © 2019 Alaattin Bedir. All rights reserved.
//

import UIKit


class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    @IBOutlet weak var highTempLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(dailyData: ResponseData) {
        
        if let time = dailyData.time {
            self.dayLabel.text = Utilities.sharedInstance.getDayFromDate(date: Double(time))
        }
        
        if let tempHigh = dailyData.apparentTemperature {
            self.highTempLabel.text = Utilities.sharedInstance.convertFahrenheitToCelsius(fahrenheit: tempHigh) 
        }
        
        if let tempLow = dailyData.temperature {
            self.lowTempLabel.text = Utilities.sharedInstance.convertFahrenheitToCelsius(fahrenheit: tempLow)
        }
        
    }
}
