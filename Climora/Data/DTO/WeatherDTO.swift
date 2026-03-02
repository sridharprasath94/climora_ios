//
//  WeatherResponseDTO.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Foundation

// MARK: - Root DTO

struct WeatherDTO: Codable {
    let location: LocationDTO
    let current: CurrentDTO

    enum CodingKeys: String, CodingKey {
        case location
        case current
    }
}

// MARK: - Location DTO

struct LocationDTO: Codable {
    let name: String
    let region: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
    }
}

// MARK: - Current DTO

struct CurrentDTO: Codable {
    let isDay: Int
    let tempC: Double
    let feelslikeC: Double
    let humidity: Int
    let uv: Double
    let condition: ConditionDTO

    enum CodingKeys: String, CodingKey {
        case isDay = "is_day"
        case tempC = "temp_c"
        case feelslikeC = "feelslike_c"
        case humidity = "humidity"
        case uv = "uv"
        case condition = "condition"
    }
}

// MARK: - Condition DTO

struct ConditionDTO: Codable {
    let text: String
    let icon: String
    let code: Int

    enum CodingKeys: String, CodingKey {
        case text
        case icon
        case code
    }
}

// MARK: - DTO → Domain Mapping

extension WeatherDTO {
    func toDomain() -> Weather {
        Weather(
            cityName: location.name,
            region: location.region,
            country: location.country,
            temperature: "\(Int(current.tempC))",
            feelsLike: "Feels like \(Int(current.feelslikeC))°C",
            humidity: "\(current.humidity)%",
            conditionText: current.condition.text,
            conditionCode: current.condition.code,
            isDay: current.isDay == 1
        )
    }
}
