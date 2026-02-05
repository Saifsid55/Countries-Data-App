//
//  AppContainer.swift
//  Countries Data App
//

import Foundation

/// AppContainer is the place where we create and connect dependencies.
///
/// File responsibility:
/// - Build and wire the app flow objects in one place.
///
/// File connections:
/// - Creates `URLSessionNetworkClient` from `Data/Network/NetworkClient.swift`.
/// - Injects that client into `CountryRepositoryImpl` from `Data/Repositories/CountryRepositoryImpl.swift`.
/// - Injects the repository into `FetchCountriesUseCaseImpl` from `Domain/UseCases/FetchCountriesUseCase.swift`.
/// - Creates UI view models in:
///   - `Presentation/SwiftUI/CountryHomeViewModel.swift`
///   - `Presentation/UIKit/HomeViewModel.swift`
final class AppContainer {
    static let shared = AppContainer()

    private init() {}

    private lazy var networkClient: NetworkClient = URLSessionNetworkClient()
    private lazy var countryRepository: CountryRepository = CountryRepositoryImpl(client: networkClient)

    func makeFetchCountriesUseCase() -> FetchCountriesUseCase {
        FetchCountriesUseCaseImpl(repository: countryRepository)
    }

    func makeCountryHomeViewModel() -> CountryHomeViewModel {
        CountryHomeViewModel(fetchCountriesUseCase: makeFetchCountriesUseCase())
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(fetchCountriesUseCase: makeFetchCountriesUseCase())
    }
}
