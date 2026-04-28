import Combine
import UIKit

@MainActor
final class WeatherViewModel {

    // MARK: - Weather state

    enum WeatherState {
        case idle
        case loading
        case success(Weather)
        case permissionDenied
        case error(String)
    }

    // MARK: - Forecast state

    enum ForecastState {
        case idle
        case loading
        case success([ForecastDay])
        case error
    }

    @Published private(set) var weatherState: WeatherState = .idle
    @Published private(set) var forecastState: ForecastState = .idle

    private var cancellables = Set<AnyCancellable>()

    private let fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCase
    private let fetchForecastUseCase: FetchForecastUseCase
    private let locationService: LocationService

    init(
        fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCase,
        fetchForecastUseCase: FetchForecastUseCase,
        locationService: LocationService
    ) {
        self.fetchCurrentWeatherUseCase = fetchCurrentWeatherUseCase
        self.fetchForecastUseCase = fetchForecastUseCase
        self.locationService = locationService
        bindLocationService()
    }

    // MARK: - Public API

    func fetchCurrentWeather(for cityName: String) {
        weatherState = .loading
        forecastState = .loading

        // Launch both in parallel — each fails independently
        Task {
            do {
                weatherState = .success(try await fetchCurrentWeatherUseCase.execute(cityName: cityName))
            } catch let error as DomainError {
                weatherState = .error(error.message)
            } catch {
                weatherState = .error("Something went wrong.")
            }
        }

        Task {
            do {
                forecastState = .success(try await fetchForecastUseCase.execute(cityName: cityName))
            } catch {
                forecastState = .error
            }
        }
    }

    func requestLocation() {
        locationService.requestLocation()
    }

    // MARK: - Private

    private func bindLocationService() {
        locationService.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self else { return }
                fetchByCoordinates(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
            .store(in: &cancellables)

        locationService.permissionDeniedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                weatherState = .permissionDenied
            }
            .store(in: &cancellables)
    }

    private func fetchByCoordinates(latitude: Double, longitude: Double) {
        weatherState = .loading
        forecastState = .loading

        Task {
            do {
                weatherState = .success(
                    try await fetchCurrentWeatherUseCase.execute(latitude: latitude, longitude: longitude)
                )
            } catch let error as DomainError {
                weatherState = .error(error.message)
            } catch {
                weatherState = .error("Something went wrong.")
            }
        }

        Task {
            do {
                forecastState = .success(
                    try await fetchForecastUseCase.execute(latitude: latitude, longitude: longitude)
                )
            } catch {
                forecastState = .error
            }
        }
    }
}
