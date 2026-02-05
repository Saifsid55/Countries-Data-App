//
//  CountryRepositoryImpl.swift
//  Countries Data App
//

import Foundation

final class CountryRepositoryImpl: CountryRepository {
    private let client: NetworkClient
    private let endpoint: String

    init(client: NetworkClient, endpoint: String = APIConfig.countriesURL) {
        self.client = client
        self.endpoint = endpoint
    }

    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        let dtos: [CountryDTO] = try await client.fetch(from: url)
        return dtos.map { $0.toDomain() }
    }
}
