//
//  AppContainer.swift
//  Countries Data App
//

import Foundation

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
