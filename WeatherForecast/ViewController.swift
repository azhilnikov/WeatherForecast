//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Alexey on 15/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    let weatherController = WeatherController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Action
    
    @IBAction func weatherForecastButtonTapped(sender: UIButton) {
        weatherController.fetchWeatherForecast({
            (result) -> Void in
            
            switch result {
            // Successfully received weather forecast
            case let .Success(weatherData):
                self.summaryLabel.text = "Summary: " + weatherData.summary
                self.humidityLabel.text = "Humidity: " + weatherData.humidity
                self.pressureLabel.text = "Pressure: " + weatherData.pressure
                self.temperatureLabel.text = "Temperature: " + weatherData.temperature
                self.errorLabel.hidden = true
                
            // Something was wrong
            case let .Failure(error):
                //print("\(error)")
                self.errorLabel.text = "\(error)"
                self.errorLabel.hidden = false
            }
        })
    }
}

