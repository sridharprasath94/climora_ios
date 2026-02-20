//
//  WeatherViewModel.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Combine
import UIKit


@MainActor
final class WeatherViewModel {

    enum State {
        case idle
        case loading
        case success(Weather)
        case permissionDenied
        case error(String)
    }

    @Published private(set) var state: State = .idle
    private var cancellables = Set<AnyCancellable>()

    private let fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCase
    private let locationService: LocationService

    init(fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCase, locationService: LocationService) {
        self.fetchCurrentWeatherUseCase = fetchCurrentWeatherUseCase
        self.locationService = locationService
        bindLocationService()
    }

    private func bindLocationService() {
        locationService.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                self.fetchCurrentWeather(for: latitude, for: longitude)
            }
            .store(in: &cancellables)
        
        locationService.permissionDeniedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.state = .permissionDenied
            }
            .store(in: &cancellables)
    }

    func fetchCurrentWeather(for cityName: String) {
        state = .loading

        Task {
            do {
                guard let weather = try await fetchCurrentWeatherUseCase
                    .execute(cityName: cityName) else {
                    state = .error("No weather data found")
                    return
                }

                state = .success(weather)

            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    func fetchCurrentWeather(for latitude: Double, for longitude: Double) {
        state = .loading

        Task {
            do {
                guard let weather = try await fetchCurrentWeatherUseCase
                    .execute(latitude: latitude, longitude: longitude) else {
                    state = .error("No weather data found")
                    return
                }

                state = .success(weather)

            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    func requestLocation() {
        locationService.requestLocation()
    }
}
