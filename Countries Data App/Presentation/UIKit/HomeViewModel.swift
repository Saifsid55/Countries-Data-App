//
//  HomeViewModel.swift
//  Countries Data App
//

import Foundation

/// UIKit home screen view model.
///
/// File responsibility:
/// - Keep countries state for table view.
/// - Fetch data and notify screen when data is ready.
/// - Give a safe accessor for each row item.
///
/// File connections:
/// - Uses `FetchCountriesUseCase` from `Domain/UseCases/FetchCountriesUseCase.swift`.
/// - Created by `AppContainer` in `App/AppContainer.swift`.
/// - Consumed by `HomeViewController` in `Presentation/UIKit/HomeViewController.swift`.
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
