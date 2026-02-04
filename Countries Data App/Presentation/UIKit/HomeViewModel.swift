//
//  HomeViewModel.swift
//  Countries Data App
//

import Foundation

protocol HomeViewModeling {
    var didFetchData: (() -> Void)? { get set }
    var numberOfCountries: Int { get }
    func dataByIndex(index: Int) -> Country?
    func fetchCountries()
}

final class HomeViewModel: HomeViewModeling {
    private let fetchCountriesUseCase: FetchCountriesUseCase
    private var countries: [Country] = []

    var didFetchData: (() -> Void)?

    init(fetchCountriesUseCase: FetchCountriesUseCase) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
    }

    var numberOfCountries: Int {
        countries.count
    }

    func dataByIndex(index: Int) -> Country? {
        guard countries.indices.contains(index) else { return nil }
        return countries[index]
    }

    func fetchCountries() {
        Task {
            do {
                countries = try await fetchCountriesUseCase.execute()
                await MainActor.run {
                    didFetchData?()
                }
            } catch {
                print("Error:", error.localizedDescription)
            }
        }
    }
}
