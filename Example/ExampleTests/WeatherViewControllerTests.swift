//
//  WeatherViewControllerTests.swift
//  ExampleTests
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import YumemiWeather
@testable import Example

class WeatherViewControllerTests: XCTestCase {

    private var weatherViewController: WeatherViewController!
    private var weatherModel: WeatherModelMock!
    private var disasterModel: DisasterModelMock!
    
    override func setUpWithError() throws {
        weatherModel = WeatherModelMock()
        disasterModel = DisasterModelMock()
        weatherViewController = R.storyboard.weather.instantiateInitialViewController()!
        weatherViewController.weatherModel = weatherModel
        weatherViewController.disasterModel = disasterModel
        _ = weatherViewController.view
    }

    func test_天気予報がsunnyだったらImageViewのImageにsunnyが設定されること_TintColorがredに設定されること() throws {
        weatherModel.fetchWeatherImpl = { _ in
            Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date())
        }
        weatherViewController.loadWeather(nil)
        waitUntilUISet()
        XCTAssertEqual(weatherViewController.weatherImageView.tintColor, R.color.red())
        XCTAssertEqual(weatherViewController.weatherImageView.image, R.image.sunny())
    }
    
    func test_天気予報がcloudyだったらImageViewのImageにcloudyが設定されること_TintColorがgrayに設定されること() throws {
        weatherModel.fetchWeatherImpl = { _ in
            Response(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date())
        }
        weatherViewController.loadWeather(nil)
        waitUntilUISet()
        XCTAssertEqual(weatherViewController.weatherImageView.tintColor, R.color.gray())
        XCTAssertEqual(weatherViewController.weatherImageView.image, R.image.cloudy())
    }
    
    func test_天気予報がrainyだったらImageViewのImageにrainyが設定されること_TintColorがblueに設定されること() throws {
        weatherModel.fetchWeatherImpl = { _ in
            Response(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date())
        }
        weatherViewController.loadWeather(nil)
        waitUntilUISet()
        XCTAssertEqual(weatherViewController.weatherImageView.tintColor, R.color.blue())
        XCTAssertEqual(weatherViewController.weatherImageView.image, R.image.rainy())
    }
    
    func test_最高気温_最低気温がUILabelに設定されること() throws {
        weatherModel.fetchWeatherImpl = { _ in
            Response(weather: .rainy, maxTemp: 100, minTemp: -100, date: Date())
        }
        weatherViewController.loadWeather(nil)
        waitUntilUISet()
        XCTAssertEqual(weatherViewController.minTempLabel.text, "-100")
        XCTAssertEqual(weatherViewController.maxTempLabel.text, "100")
    }
    
    private func waitUntilUISet() {
        let expectation = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
}

class WeatherModelMock: WeatherModel {
    
    var fetchWeatherImpl: ((Request) throws -> Response)!
    
    func fetchWeather(at area: String,
                      date: Date,
                      completion: @escaping (Result<Response, WeatherError>) -> Void) {
        let request = Request(area: area, date: date)
        let response = try! fetchWeatherImpl(request)
        completion(.success(response))
    }
    
    func fetchWeather(_ request: Request) throws -> Response {
        return try fetchWeatherImpl(request)
    }
    
}

class DisasterModelMock: DisasterModel {
    
    func fetchDisaster(completion: ((String) -> Void)?) {
        completion?("")
    }
    
}
