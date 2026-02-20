//
//  Weather.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//


// MARK: - Theme

enum WeatherTheme {
    case day
    case night
}

import Foundation

// MARK: - Domain Entity
struct Weather {
    let cityName: String
    let region: String
    let country: String
    
    let temperature: String
    let feelsLike: String
    let humidity: String

    let conditionText: String
    let conditionCode: Int
    
    let isDay: Bool
    var theme: WeatherTheme {
        return isDay ? .day : .night
    }
    var conditionIconAssetName: String {
        switch conditionCode {
        case 1000:
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1003:
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 1006, 1009:
            return "cloud.fill"
        case 1030, 1135, 1147:
            return "cloud.fog.fill"
        case 1063, 1150, 1153, 1180, 1183, 1240:
            return "cloud.drizzle.fill"
        case 1186, 1189, 1243:
            return "cloud.rain.fill"
        case 1192, 1195, 1246:
            return "cloud.heavyrain.fill"
        case 1066, 1210, 1213, 1255:
            return "cloud.snow.fill"
        case 1216, 1219, 1258:
            return "cloud.snow.fill"
        case 1222, 1225:
            return "snowflake"
        case 1087, 1273, 1276, 1279, 1282:
            return "cloud.bolt.fill"
        default:
            return "cloud.fill"
        }
    }
}

extension WeatherTheme {
    var appTheme: AppTheme {
        switch self {
        case .day:
            return .day
        case .night:
            return .night
        }
    }
}
