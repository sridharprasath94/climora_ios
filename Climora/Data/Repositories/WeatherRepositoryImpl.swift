final class WeatherRepositoryImpl: WeatherRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchWeather(cityName: String) async throws -> Weather {
        do {
            let dto: WeatherDTO = try await apiClient.request(
                EndPoint.currentWeatherByCity(city: cityName)
            )
            return dto.toDomain()
        } catch let apiError as APIError {
            throw apiError.toDomainError()
        } catch {
            throw DomainError.unknown(error)
        }
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        do {
            let dto: WeatherDTO = try await apiClient.request(
                EndPoint.currentWeatherByCoordinates(
                    latitude: latitude,
                    longitude: longitude
                )
            )
            return dto.toDomain()
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
        case .rateLimitExceeded:
            return .unauthorized
        case .invalidResponse:
            return .invalidResponse
        case .invalidStatusCode:
            return .invalidRequest
        case .network:
            return .networkFailure
        case .decoding:
            return .decodingFailure
        }
    }
}
