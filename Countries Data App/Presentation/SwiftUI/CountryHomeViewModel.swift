//
//  CountryHomeViewModel.swift
//  Countries Data App
//

import SwiftUI

@MainActor
final class CountryHomeViewModel: ObservableObject {
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
