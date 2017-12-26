//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Raju Potharaju on 21/12/17.
//  Copyright © 2017 Raju Potharaju. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

protocol  WeatherViewModelDelegate {
    func didFinishLoadingWeatherDatawithError(withError error: Error?)
    func didFinishLoadingWeatherData(withData data:Array<Any>)

}
extension Date {
    func getTimeStampwithFormat(_ format:String)->String{
        let dateFormat = format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}
class WeatherViewModel: NSObject {

    var weatherData: NSArray?
    var delegate: WeatherViewModelDelegate?
    let weatherAPI = WeatherHelper()

    func getWeatherData(address: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        _ = weatherAPI.getWeather(address: address).then { weather -> Void in
            self.weatherData = weather as NSArray
            return (self.delegate?.didFinishLoadingWeatherData(withData:weather))!
            }.catch { error in
                
                
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

    }

}
