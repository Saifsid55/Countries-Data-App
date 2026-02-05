//
//  CountryRepository.swift
//  Countries Data App
//

import Foundation

/// Repository contract for country data.
///
/// File responsibility:
/// - Define what domain layer needs from data layer.
///
/// File connections:
/// - Implemented by `CountryRepositoryImpl` in `Data/Repositories/CountryRepositoryImpl.swift`.
/// - Called by `FetchCountriesUseCaseImpl` in `Domain/UseCases/FetchCountriesUseCase.swift`.
protocol CountryRepository {
    func fetchCountries() async throws -> [Country]
}
