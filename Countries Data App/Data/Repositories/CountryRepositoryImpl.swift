//
//  CountryRepositoryImpl.swift
//  Countries Data App
//

import Foundation

/// Data repository implementation for countries.
///
/// File responsibility:
/// - Convert API endpoint string into URL.
/// - Ask network layer to fetch DTO models.
/// - Map DTOs into domain entities.
///
/// File connections:
/// - Uses `NetworkClient` from `Data/Network/NetworkClient.swift`.
/// - Uses DTO mapping from `Data/DTOs/CountryDTO.swift`.
/// - Conforms to `CountryRepository` from `Domain/Repositories/CountryRepository.swift`.
/// - Injected by `AppContainer` in `App/AppContainer.swift`.


final class CountryRepositoryImpl: CountryRepository {
    private let client: NetworkClient
    private let endpoint: URL?

    init(client: NetworkClient, endpoint: URL? = APIConfig.countries.url) {
        self.client = client
        self.endpoint = endpoint
    }

    func fetchCountries() async throws -> [Country] {
        guard let url = endpoint else {
            throw URLError(.badURL)
        }
        let dtos: [CountryDTO] = try await client.fetch(from: url)
        return dtos.map { $0.toDomain() }
    }
}
