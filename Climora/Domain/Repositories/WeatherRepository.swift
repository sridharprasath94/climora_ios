//
//  WeatherRepository.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Foundation

protocol WeatherRepository {
    func fetchWeather(cityName : String) async throws -> Weather?
    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather? 
}
