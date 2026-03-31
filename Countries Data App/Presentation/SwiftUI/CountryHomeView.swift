//
//  CountryHomeView.swift
//  Countries Data App
//

import SwiftUI

/// SwiftUI list screen for countries.
///
/// File responsibility:
/// - Render countries list.
/// - Trigger data loading when screen appears.
/// - Navigate to detail screen after selecting a country.
///
/// File connections:
/// - Reads state from `CountryHomeViewModel` in `Presentation/SwiftUI/CountryHomeViewModel.swift`.
/// - Opens `CountryDetailView` in `Presentation/SwiftUI/CountryDetailView.swift`.
/// - Uses `AppContainer` in `App/AppContainer.swift` to get default dependencies.



struct CountryHomeView<ViewModel: CountryHomeViewModeling>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
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
                            HStack {
                                Text(country.flag)
                                    .font(.largeTitle)

                                Text(country.name.official)
                                    .padding(.vertical, 8)
                                    .padding(.leading, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.leading, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationDestination(item: $viewModel.selectedCountry) { country in
                CountryDetailView(country: country)
            }
            .task {
                await viewModel.fetchData()
            }
        }
        .navigationTitle("Countries")
    }
}

extension CountryHomeView where ViewModel == CountryHomeViewModel {
    init(viewModel: CountryHomeViewModel = AppContainer.shared.makeCountryHomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
