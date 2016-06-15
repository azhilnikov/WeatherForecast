//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by Alexey on 15/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAsynchronousURLConnection() {
        
        let location = CLLocationCoordinate2DMake(-33.827759327657603, 151.23060078319645)
        
        let url = WeatherForecastAPI.url(location)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { data, response, error in
            
            XCTAssertNotNil(data, "Data should not be nil!")
            XCTAssertNil(error, "Error should be nil!")
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200!")
            } else {
                XCTFail("Response is not NSHTTPURLResponse!")
            }
            
            let result = WeatherForecastAPI.dataFromJSON(data!)
            if case let .Failure(error) = result {
                XCTFail("\(error)")
            }
        }
        task.resume()
    }
}
