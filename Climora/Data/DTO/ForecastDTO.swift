import Foundation

// MARK: - Root

struct ForecastResponseDTO: Codable {
    let location: LocationDTO
    let current: CurrentDTO
    let forecast: ForecastContainerDTO
}

// MARK: - Forecast container

struct ForecastContainerDTO: Codable {
    let forecastday: [ForecastDayDTO]
}

struct ForecastDayDTO: Codable {
    let date: String
    let day: DayDTO
}

struct DayDTO: Codable {
    let mintempC: Double
    let maxtempC: Double
    let condition: ConditionDTO

    enum CodingKeys: String, CodingKey {
        case mintempC = "mintemp_c"
        case maxtempC = "maxtemp_c"
        case condition
    }
}

// MARK: - DTO → Domain

extension ForecastResponseDTO {
    func toDomainForecast() -> [ForecastDay] {
        forecast.forecastday.map { day in
            ForecastDay(
                date: day.date,
                minTemp: day.day.mintempC,
                maxTemp: day.day.maxtempC,
                conditionCode: day.day.condition.code,
                conditionText: day.day.condition.text
            )
        }
    }
}
