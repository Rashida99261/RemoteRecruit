//
//  APIClient.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

final class APIClient: APIClientProtocol {
    static let shared = APIClient()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw NetworkError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:              return "Invalid URL."
        case .invalidResponse:         return "Server returned an invalid response."
        case .decodingFailed(let e):   return "Decoding failed: \(e.localizedDescription)"
        }
    }
}
