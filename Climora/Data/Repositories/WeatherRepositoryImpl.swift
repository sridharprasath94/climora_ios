final class WeatherRepositoryImpl: WeatherRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    // MARK: - Current Weather

    func fetchWeather(cityName: String) async throws -> Weather {
        try await perform {
            let dto: WeatherDTO = try await self.apiClient.request(
                EndPoint.currentWeatherByCity(city: cityName)
            )
            return dto.toDomain()
        }
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        try await perform {
            let dto: WeatherDTO = try await self.apiClient.request(
                EndPoint.currentWeatherByCoordinates(latitude: latitude, longitude: longitude)
            )
            return dto.toDomain()
        }
    }

    // MARK: - Forecast

    func fetchForecast(cityName: String, days: Int) async throws -> [ForecastDay] {
        try await perform {
            let dto: ForecastResponseDTO = try await self.apiClient.request(
                EndPoint.forecastByCity(city: cityName, days: days)
            )
            return dto.toDomainForecast()
        }
    }

    func fetchForecast(latitude: Double, longitude: Double, days: Int) async throws -> [ForecastDay] {
        try await perform {
            let dto: ForecastResponseDTO = try await self.apiClient.request(
                EndPoint.forecastByCoordinates(latitude: latitude, longitude: longitude, days: days)
            )
            return dto.toDomainForecast()
        }
    }

    // MARK: - Error mapping

    private func perform<T>(_ block: () async throws -> T) async throws -> T {
        do {
            return try await block()
        } catch let apiError as APIError {
            throw apiError.toDomainError()
        } catch {
            throw DomainError.unknown(error)
        }
    }
}

private extension APIError {
    func toDomainError() -> DomainError {
        switch self {
        case .rateLimitExceeded: return .unauthorized
        case .invalidResponse: return .invalidResponse
        case .invalidStatusCode: return .invalidRequest
        case .network: return .networkFailure
        case .decoding: return .decodingFailure
        }
    }
}
