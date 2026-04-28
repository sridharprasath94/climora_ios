final class FetchForecastUseCase {
    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func execute(cityName: String, days: Int = 3) async throws -> [ForecastDay] {
        try await repository.fetchForecast(cityName: cityName, days: days)
    }

    func execute(latitude: Double, longitude: Double, days: Int = 3) async throws -> [ForecastDay] {
        try await repository.fetchForecast(latitude: latitude, longitude: longitude, days: days)
    }
}
