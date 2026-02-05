//
//  FetchCountriesUseCase.swift
//  Countries Data App
//

import Foundation

protocol FetchCountriesUseCase {
    func execute() async throws -> [Country]
}

struct FetchCountriesUseCaseImpl: FetchCountriesUseCase {
    private let repository: CountryRepository

    init(repository: CountryRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Country] {
        try await repository.fetchCountries()
    }
}
