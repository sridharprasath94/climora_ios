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
    let is_day: Int
    let temp_c: Double
    let feelslike_c: Double
    let humidity: Int
    let uv: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case is_day = "is_day"
        case temp_c = "temp_c"
        case feelslike_c = "feelslike_c"
        case humidity = "humidity"
        case uv = "uv"
        case condition = "condition"
    }
}

// MARK: - Condition DTO

struct ConditionDTO: Codable {
    let text: String
    let icon: String
    let code : Int
    
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
            temperature: "\(Int(current.temp_c))",
            feelsLike: "Feels like \(Int(current.feelslike_c))°C",
            humidity: "\(current.humidity)%",
            conditionText: current.condition.text,
            conditionCode: current.condition.code,
            isDay: current.is_day == 1
        )
    }
}
