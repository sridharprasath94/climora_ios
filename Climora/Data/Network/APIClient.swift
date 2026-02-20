//
//  APIClient.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ request: APIRequest) async throws -> T
}


/// Lightweight networking client responsible for executing API requests
/// and decoding JSON responses.
final class APIClient: APIClientProtocol {

    
    // MARK: - Initialization
    
    /// Public initializer for dependency injection
    init() {}
    
    // MARK: - Properties
    
    /// JSON decoder configured for API responses
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .deferredToDate
        return decoder
    }()
    
    
    // MARK: - Public API
    
    /// Executes an APIRequest and decodes the result into the expected type.
    func request<T: Decodable>(_ requestProvider: APIRequest) async throws -> T {
        let request : URLRequest = requestProvider.urlRequest
        
        let (data, response) : (Data, URLResponse)  = try await perform(request: request)
        try validate(response: response)
        
        print("Decoding type:", T.self)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON:\n\(jsonString)")
        } else {
            print("Unable to convert data to string")
        }
        return try decode(data: data)
    }
}
    
extension APIClient {
    // MARK: - Private Helpers

    /// Performs the URLSession request
    private func perform(request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.network(error)
        }
    }
    
    /// Validates HTTP response status code
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            switch httpResponse.statusCode {
            case 403:
                throw APIError.rateLimitExceeded
            case 409:
                throw APIError.invalidStatusCode(409)
            default:
                throw APIError.invalidStatusCode(httpResponse.statusCode)
            }
        }
    }
    
    /// Decodes raw JSON data into a model
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
