//
//  EndPoint.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Foundation

protocol APIRequest {
    var urlRequest: URLRequest { get }
}

/// Represents all API endpoints used in the app.
/// Responsible only for URL construction and request configuration.
enum EndPoint: APIRequest {
    // MARK: - Cases
    case currentWeatherByCity(city: String)
    case currentWeatherByCoordinates(latitude: Double, longitude: Double)
    case forecastByCity(city: String, days: Int)
    
    // MARK: - URL Request
    var urlRequest: URLRequest {
        var components = URLComponents(
            url: AppConfig.Weather.baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!
        
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}

extension EndPoint {
    // MARK: - Path
    private var path: String {
        switch self {
        case .currentWeatherByCity,
             .currentWeatherByCoordinates:
            return "/current.json"
        case .forecastByCity:
            return "/forecast.json"
        }
    }
    
    // MARK: - Query Items
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .currentWeatherByCity(let city):
            return [
                URLQueryItem(name: "key", value: AppConfig.Weather.apiKey),
                URLQueryItem(name: "q", value: city)
            ]

        case .currentWeatherByCoordinates(let latitude, let longitude):
            return [
                URLQueryItem(name: "key", value: AppConfig.Weather.apiKey),
                URLQueryItem(name: "q", value: "\(latitude),\(longitude)")
            ]

        case .forecastByCity(let city, let days):
            return [
                URLQueryItem(name: "key", value: AppConfig.Weather.apiKey),
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "days", value: "\(days)")
            ]
        }
    }
}
