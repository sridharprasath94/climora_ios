//
//  APIError.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Foundation


// MARK: - Errors
enum APIError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(Int)
    case rateLimitExceeded
    case network(Error)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .invalidStatusCode(let code):
            return "Server returned error code: \(code)."
        case .rateLimitExceeded:
            return "GitHub API rate limit exceeded. Please try again later."
        case .network(let error):
            return error.localizedDescription
        case .decoding(let error):
            return "Failed to decode server response: \(error.localizedDescription)"
        }
    }
}
