//
//  WeatherForecastAPI.swift
//  WeatherForecast
//
//  Created by Alexey on 15/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import Foundation
import CoreLocation

enum WeatherServerResult {
    case Success(Weather)
    case Failure(ErrorType)
}

enum WeatherServerError: ErrorType {
    case UknownLocation
    case InvalidJSONData
}

struct WeatherForecastAPI {
    
    private static let apiKey = "e3cadd3ccd83cfebfb3e78fd5041888b"
    private static let url = "https://api.forecast.io/forecast/"
    
    private static let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        return nf
    }()
    
    // Create absolute url using coordinates of current location
    static func url(location: CLLocationCoordinate2D) -> NSURL {
        
        // Add API key and coordinates to the url
        let urlString = url + apiKey + "/" + String(location.latitude) + "," + String(location.longitude)
        
        let components = NSURLComponents(string: urlString)!
        
        // List of query items
        let parameters = ["units": "si"]
        
        var queryItems = [NSURLQueryItem]()
        for (key, value) in parameters {
            // Add query items
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        // Return full url
        components.queryItems = queryItems
        return components.URL!
    }
    
    // Extract data from JSON object
    static func dataFromJSON(data: NSData) -> WeatherServerResult {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            // Parse necessary data
            guard
                let jsonDictionary = json as? NSDictionary,
                let currently = jsonDictionary["currently"] as? NSDictionary,
                let summary = currently["summary"] as? String,
                let temperature = currently["temperature"] as? Double,
                let humidity = currently["humidity"] as? Double,
                let pressure = currently["pressure"] as? Double else {
                    // Can't find all necessary fields
                    return .Failure(WeatherServerError.InvalidJSONData)
            }
            
            // Convert numbers into strings
            guard
                let stringTemperature = numberFormatter.stringFromNumber(temperature),
                let stringHumidity = numberFormatter.stringFromNumber(humidity * 100),
                let stringPressure = numberFormatter.stringFromNumber(pressure) else {
                    // JSON data is wrong
                    return .Failure(WeatherServerError.InvalidJSONData)
            }
            
            // Create a weather object with current information
            let weather = Weather(summary: summary,
                                  temperature: stringTemperature,
                                  humidity: stringHumidity,
                                  pressure: stringPressure)
            return .Success(weather)
        }
        catch let error {
            // Something is wrong with JSON data
            return .Failure(error)
        }
    }
}
