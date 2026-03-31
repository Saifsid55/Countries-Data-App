//
//  CountryHomeViewModel.swift
//  Countries Data App
//

import SwiftUI
import Combine

/// SwiftUI home screen view model.
///
/// File responsibility:
/// - Hold countries list for SwiftUI screen.
/// - Load data using the use case.
/// - Store selected country for navigation.
///
/// File connections:
/// - Uses `FetchCountriesUseCase` from `Domain/UseCases/FetchCountriesUseCase.swift`.
/// - Created by `AppContainer` in `App/AppContainer.swift`.
/// - Read by `CountryHomeView` in `Presentation/SwiftUI/CountryHomeView.swift`.

@MainActor
protocol CountryHomeViewModeling: ObservableObject {
    var countries: [Country] { get set }
    var selectedCountry: Country? { get set }
    func fetchData() async
}

@MainActor
final class CountryHomeViewModel: CountryHomeViewModeling {
    @Published var countries: [Country] = []
    @Published var selectedCountry: Country?
    
    private let fetchCountriesUseCase: FetchCountriesUseCase

    init(fetchCountriesUseCase: FetchCountriesUseCase) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
    }

    func fetchData() async {
        do {
            countries = try await fetchCountriesUseCase.execute()
        } catch {
            print("Error:", error.localizedDescription)
        }
    }
}
