//
//  NetworkClient.swift
//  Countries Data App
//

import Foundation

protocol NetworkClient {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

final class URLSessionNetworkClient: NetworkClient {
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum APIConfig {
    static let countriesURL = "https://restcountries.com/v3.1/independent?status=true&fields=languages,capital,flag,name"
}
