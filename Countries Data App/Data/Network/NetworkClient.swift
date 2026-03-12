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
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
enum APIConfig {
    case countries
    
    var url: URL? {
        switch self {
        case .countries:
            return URL(string: "https://restcountries.com/v3.1/independent?status=true&fields=languages,capital,flag,name")
        }
    }
}
