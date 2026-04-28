import Foundation

protocol WeatherRepository {
    func fetchWeather(cityName: String) async throws -> Weather
    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather
    func fetchForecast(cityName: String, days: Int) async throws -> [ForecastDay]
    func fetchForecast(latitude: Double, longitude: Double, days: Int) async throws -> [ForecastDay]
}
