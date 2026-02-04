//
//  CountryHomeView.swift
//  Countries Data App
//

import SwiftUI

struct CountryHomeView: View {
    @StateObject private var viewModel: CountryHomeViewModel

    init(viewModel: CountryHomeViewModel = AppContainer.shared.makeCountryHomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.countries, id: \.name.official) { country in
                        Button {
                            viewModel.selectedCountry = country
                        } label: {
                            Text(country.name.official)
                                .padding(.vertical, 8)
                                .padding(.leading, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top)
            .navigationTitle("Countries")
            .navigationDestination(item: $viewModel.selectedCountry) { country in
                CountryDetailView(country: country)
            }
            .task {
                await viewModel.fetchData()
            }
        }
    }
}
