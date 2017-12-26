//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by Raju Potharaju on 21/12/17.
//  Copyright © 2017 Raju Potharaju. All rights reserved.
//

import UIKit
fileprivate var appID = "27a0420d7f899376a73505b09614889e"
import PromiseKit

extension String {
    
    func getDateFromString()->Date?{
        let dateFormat = "yyyy-MM-dd HH:ss:zz"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
        
    }
    
}

class WeatherHelper: NSObject {

    struct Weather {
        
        var date:Date!
        var temperature:Double!
        var weatherDescription:String!
        
        init?(jsonDict:Dictionary<String, AnyObject>) {
            
            guard let dateStr = jsonDict["dt_txt"] as? String,
                let date = dateStr.getDateFromString(),
                let mainDict = jsonDict["main"] as? Dictionary<String, AnyObject>,
                let temperature = mainDict["temp"] as? Double,
                let weather = (jsonDict["weather"] as? [Dictionary<String, AnyObject>])?.first,
                let weatherDesc = weather["description"] as? String
                else {
                    return nil
            }
            
            self.date = date
            self.temperature = temperature
            self.weatherDescription = weatherDesc
        }
        
        
    }

    
    func getWeather(address: String) -> Promise<Array<Any>> {
        
        return Promise { fulfill, reject in
            
            let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=\(address)&appid=\(appID)"
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let dataPromise: URLDataPromise = session.dataTask(with: request)
            
            _ = dataPromise.asDictionary().then { dictionary -> Void in
                
                var weatherObjects:[Weather]?
                guard let list = dictionary["list"] as? [Dictionary<String, AnyObject>] else {
                    let error = NSError(domain: "PromiseKitTutorial", code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                    reject(error)
                    return
                }
                weatherObjects = Array()
                for item in list {
                    
                    if let weather = Weather(jsonDict: item) {
                        weatherObjects?.append(weather)
                    }
                }
                weatherObjects!.sort(by: { $0.date.compare($1.date) == .orderedAscending})
                fulfill(weatherObjects!)
                
                }.catch(execute: reject)
        }
    }
}
