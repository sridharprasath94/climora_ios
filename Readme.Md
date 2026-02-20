# 🌤 Climora

Climora is a scalable iOS weather application built using **Clean Architecture** principles and modern Swift practices.

It demonstrates clean separation of concerns using MVVM, UseCases, Repository pattern, and Dependency Injection.

---

## 🏗 Architecture

The project follows a layered Clean Architecture structure:

- **App** – Application lifecycle & dependency container
- **Core** – Shared utilities, constants, and theme configuration
- **Data** – DTOs, API client, services, and repository implementations
- **Domain** – Entities, repository contracts, and use cases
- **Presentation** – ViewControllers and ViewModels

This ensures scalability, maintainability, and testability.

---

## ✨ Features

- Search weather by city name
- Fetch weather using current location (CoreLocation)
- Async/Await networking
- Dynamic Day/Night theme switching
- Background image adaptation based on weather state
- Error handling & permission management
- Secure API configuration using `.xcconfig`

---

## 🔐 Configuration

The project uses `Config.xcconfig` to securely store API keys.

To run the project locally:

1. Copy:
   ```
   Config.xcconfig.example
   ```
2. Rename it to:
   ```
   Config.xcconfig
   ```
3. Add your Weather API key.

The real `Config.xcconfig` file is ignored via `.gitignore`.

---

## 🛠 Requirements

- iOS 17+
- Xcode 15+
- Swift 5.9+

---

## 📌 Purpose

This project serves as a portfolio-ready demonstration of scalable iOS architecture and modern development patterns.
