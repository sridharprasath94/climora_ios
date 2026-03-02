//
//  DomainError+Presentation.swift
//  Climora
//
//  Created by Sridhar Prasath on 02.03.26.
//

extension DomainError {
    var message: String {
        switch self {
        case .networkFailure:
            return "Please check your internet connection."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingFailure:
            return "Failed to process weather data."
        case .unauthorized:
            return "Unauthorized request."
        case .notFound:
            return "Weather data not found."
        case .invalidRequest:
            return "Invalid request."
        case .unknown:
            return "Something went wrong."
        }
    }
}
