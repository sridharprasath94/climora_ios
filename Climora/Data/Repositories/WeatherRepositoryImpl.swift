//
//  WeatherRepositoryImpl.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

final class WeatherRepositoryImpl: WeatherRepository {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchWeather(cityName: String) async throws -> Weather? {
        let dto : WeatherDTO = try await apiClient.request(EndPoint.currentWeatherByCity(city: cityName))
        
        return dto.toDomain()
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather? {
        let dto: WeatherDTO = try await apiClient.request(
            EndPoint.currentWeatherByCoordinates(latitude: latitude, longitude: longitude)
        )
        
        return dto.toDomain()
    }
    
}
