//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Wipro on 23/12/17.
//  Copyright © 2017 Raju Potharaju. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellWith(_ weather: WeatherHelper.Weather) {
        
        guard let description = weather.weatherDescription else{
            return
        }
        self.weatherDescriptionLabel.text = description
        
        guard let temperature = weather.temperature else{
            return
        }
        temperatureLabel.text = "\(temperature)" + " kelvin"
        
        guard let date = weather.date else{
            return
        }
        dateLabel.text = date.getTimeStampwithFormat("dd-MM-yyyy h:mm a")
        
    }
}
