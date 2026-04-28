# Climora – iOS Weather App

Climora is a production-quality iOS weather application built with **Clean Architecture** and **MVVM**. It is designed for scalability, testability, and maintainability — with a clear separation between data, domain, and presentation layers.

---

## Architecture

The project follows **Clean Architecture** with three distinct layers:

```
App/
├── Data/           # DTOs, API client, repository implementations, location service
├── Domain/         # Entities, repository protocols, use cases, domain errors
└── Presentation/   # ViewModels (MVVM), ViewControllers, UI components
```

### Layer Responsibilities

| Layer | Responsibility |
|---|---|
| **Domain** | Pure Swift. Defines `Weather`, `ForecastDay` entities, `WeatherRepository` protocol, `FetchCurrentWeatherUseCase`, `FetchForecastUseCase`, and `DomainError`. No UIKit or framework dependencies. |
| **Data** | Implements `WeatherRepository`. Owns the `APIClient`, `EndPoint` enum, `WeatherDTO`/`ForecastDTO` response models, and `CoreLocationService`. Maps raw API responses to domain models. |
| **Presentation** | `WeatherViewModel` publishes `@Published` state enums consumed by `WeatherViewController` via Combine. |
| **App** | `AppContainer` wires all dependencies and creates the initial view controller. `AppConfig` loads the API key from `.xcconfig`. |

### Key Patterns

- **Repository Pattern** — `WeatherRepository` protocol in Domain; `WeatherRepositoryImpl` in Data. The presentation layer never touches the network directly.
- **Use Case Layer** — `FetchCurrentWeatherUseCase` and `FetchForecastUseCase` encapsulate business logic. Each has overloads for city-name and coordinate-based lookups.
- **MVVM + Combine** — `WeatherViewModel` exposes `@Published var weatherState` and `@Published var forecastState`. The view subscribes with `sink` and reacts to state changes.
- **Dependency Injection** — All dependencies flow through `AppContainer` using constructor injection. No singletons or service locators.
- **Parallel async loading** — Current weather and 3-day forecast are fetched concurrently using two independent `Task {}` blocks. Each fails independently without cancelling the other.

---

## Features

- Search weather by city name
- Current location weather via CoreLocation
- 3-day forecast loaded in parallel with current weather
- Humidity and feels-like detail card
- Dynamic background based on weather condition
- Adaptive light/dark mode
- Secure API key injection via `.xcconfig`

---

## Project Structure

```
Climora/
├── App/
│   ├── AppConfig.swift               # Reads API key from xcconfig
│   ├── AppContainer.swift            # Dependency wiring
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Core/
│   └── Constants/
│       ├── AppTheme.swift            # Weather condition → theme mapping
│       ├── Colors.swift              # Semantic AppColors (light/dark)
│       └── Constants.swift
├── Data/
│   ├── DTO/
│   │   ├── WeatherDTO.swift          # Current weather response + mapping
│   │   └── ForecastDTO.swift         # Forecast response + mapping
│   ├── Network/
│   │   ├── APIClient.swift           # Generic URLSession-based client
│   │   ├── APIError.swift
│   │   └── EndPoint.swift            # URL construction per endpoint
│   ├── Repositories/
│   │   └── WeatherRepositoryImpl.swift
│   └── Services/
│       └── CoreLocationService.swift
├── Domain/
│   ├── Entities/
│   │   ├── Weather.swift
│   │   └── ForecastDay.swift
│   ├── Error/
│   │   └── DomainError.swift
│   ├── Repositories/
│   │   └── WeatherRepository.swift   # Protocol
│   └── UseCases/
│       ├── FetchCurrentWeatherUseCase.swift
│       └── FetchForecastUseCase.swift
└── Presentation/
    ├── DomainError+Presentation.swift # Error → user-facing message mapping
    └── Weather/
        ├── View/
        │   ├── WeatherViewController.swift
        │   ├── WeatherViewController+Alerts.swift
        │   ├── WeatherViewController+Delegates.swift
        │   └── ForecastCell.swift
        └── ViewModel/
            └── WeatherViewModel.swift
```

---

## Tech Stack

| Technology | Usage |
|---|---|
| Swift | Primary language |
| UIKit | UI (Storyboard + programmatic views) |
| Combine | Reactive state binding (ViewModel → ViewController) |
| Swift Concurrency | `async/await` for all network calls |
| CoreLocation | Device GPS coordinates |
| URLSession | HTTP networking (no third-party networking library) |
| SwiftLint | Code style enforcement |

---

## Configuration

The project uses `.xcconfig` to inject the API key at build time without committing secrets.

1. Copy `Config.xcconfig.example` and rename it to `Config.xcconfig`
2. Add your [WeatherAPI](https://www.weatherapi.com) key:
   ```
   WEATHER_API_KEY = your_api_key_here
   ```
3. Build and run — `AppConfig` reads the key from the bundle's `Info.plist`.

`Config.xcconfig` is excluded from version control via `.gitignore`.

---

## Requirements

| Requirement | Version |
|---|---|
| iOS | 17.0+ |
| Xcode | 16.0+ |
| Swift | 5.10+ |
