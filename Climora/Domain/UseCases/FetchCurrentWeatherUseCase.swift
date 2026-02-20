//
//  FetchCurrentWeatherUseCase.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

final class FetchCurrentWeatherUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(cityName: String) async throws -> Weather? {
        try await repository.fetchWeather(cityName: cityName)
    }
    
    func execute(latitude: Double, longitude: Double) async throws -> Weather? {
        try await repository.fetchWeather(latitude: latitude, longitude: longitude)
    }
}
