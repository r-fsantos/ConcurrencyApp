//
//  ApiError.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 27/06/25.
//

import Foundation

// Define an enum for potential API errors to make error handling more robust.
enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknownError

    var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
