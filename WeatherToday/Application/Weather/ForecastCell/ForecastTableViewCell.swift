//
//  ForecastTableViewCell.swift
//  WeatherTodayApp
//
//  Created by mac on 1.09.2019.
//  Copyright © 2019 Alaattin Bedir. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    // Outletss
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
