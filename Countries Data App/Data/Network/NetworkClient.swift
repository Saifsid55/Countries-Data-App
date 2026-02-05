//
//  NetworkClient.swift
//  Countries Data App
//

import Foundation

/// Network layer is responsible for fetching data from remote APIs.
///
/// File responsibility:
/// - Define a small network contract (`NetworkClient`).
/// - Provide a URLSession-based implementation (`URLSessionNetworkClient`).
/// - Keep API endpoint constants in one place (`APIConfig`).
///
/// File connections:
/// - `CountryRepositoryImpl` in `Data/Repositories/CountryRepositoryImpl.swift` calls this layer.
/// - `AppContainer` in `App/AppContainer.swift` creates and injects this client.
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
