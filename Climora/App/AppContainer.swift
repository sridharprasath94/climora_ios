//
//  AppContainer.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import UIKit

final class AppContainer {
    
    // MARK: - Infrastructure
    
    private lazy var apiClient: APIClientProtocol = APIClient()
    

    // MARK: - Repositories
    
    private lazy var weatherRepository: WeatherRepository =
    WeatherRepositoryImpl(apiClient: apiClient)
    
    // MARK: - UseCases
    
    private lazy var fetchCurrentWeatherUseCase = FetchCurrentWeatherUseCase(repository: weatherRepository)
    
    // MARK: - Location Service
    private lazy var locationService: LocationService = CoreLocationService()
    
    // MARK: - Factory
    
    @MainActor func makeWeatherViewController() -> UIViewController {
        let viewModel = WeatherViewModel(
            fetchCurrentWeatherUseCase: fetchCurrentWeatherUseCase,
            locationService: locationService
        )

        return WeatherViewController.create(with: viewModel)
    }
}
