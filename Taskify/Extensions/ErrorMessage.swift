//
//  ErrorMessage.swift
//  Taskify
//
//  Created by Tatiana Simmer on 13/02/2024.
//

import Foundation

enum APIError: Error {
    case unknownError
    case invalidData
    case authenticationError
    case serverUnavailable
    case decodingError

    var errorMessage: String {
        switch self {
        case .unknownError:
            return "Unexpected response from the server"
        case .invalidData:
            return "Invalid data received"
        case .authenticationError:
            return "Authentication failed"
        case .serverUnavailable:
            return "The server is currently unavailable"
        case .decodingError:
            return "Decoding Error"
        }
    }
}
