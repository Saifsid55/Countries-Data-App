//
//  FetchCountriesUseCase.swift
//  Countries Data App
//

import Foundation

/// Use case layer is responsible for business actions.
///
/// File responsibility:
/// - Define the app action: fetch countries.
/// - Keep UI independent from repository details.
///
/// File connections:
/// - Uses `CountryRepository` from `Domain/Repositories/CountryRepository.swift`.
/// - Called by view models in:
///   - `Presentation/UIKit/HomeViewModel.swift`
///   - `Presentation/SwiftUI/CountryHomeViewModel.swift`
/// - Built by `AppContainer` in `App/AppContainer.swift`.
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
