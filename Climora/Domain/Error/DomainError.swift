//
//  DomainError.swift
//  Climora
//
//  Created by Sridhar Prasath on 02.03.26.
//

import Foundation

enum DomainError: Error {
    case networkFailure
    case invalidResponse
    case decodingFailure
    case unauthorized
    case notFound
    case invalidRequest
    case unknown(Error)
}
