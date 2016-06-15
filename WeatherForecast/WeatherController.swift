//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Alexey on 15/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherController: NSObject, CLLocationManagerDelegate {
    
    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        // Let's detect current location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    // Get weather forecast
    func fetchWeatherForecast(completion: (WeatherServerResult) -> Void) {
        guard let locaition = currentLocation else {
            // Current location is unknown
            completion(.Failure(WeatherServerError.UknownLocation))
            return
        }
        
        // Get url
        let url = WeatherForecastAPI.url(locaition)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processWeatherRequest(data, error: error)
            dispatch_async(dispatch_get_main_queue(), {
                // Return results
                completion(result)
            })
        }
        task.resume()
    }
    
    // MARK: - Location manager delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            // Detected current location, stop updating location
            locationManager.stopUpdatingLocation()
            currentLocation = location
        }
    }
    
    // MARK: - Private method
    
    // Extract data from JSON object
    private func processWeatherRequest(data: NSData?, error: NSError?) -> WeatherServerResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return WeatherForecastAPI.dataFromJSON(jsonData)
    }
}
