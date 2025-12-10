//
//  CountryHomeView.swift
//  Countries Data App
//
//  Created by Mohd Saif on 09/12/25.
//

import SwiftUI

struct CountryHomeView: View {
    @StateObject var vm = CountryHomeVM()
    var body: some View {
//        List(vm.countriesData ?? [], id: \.name.official) { country in
//            Text(country.name.official)
//        }
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(vm.countriesData ?? [], id: \.name.official) { country in
                        Text(country.name.official)
                            .padding(.vertical, 8)
                            .padding(.leading, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                vm.selectedCountry = country
                            }
                    }
                }
            }
            .padding(.top)
            .navigationDestination(item: $vm.selectedCountry) { country in
                CountryDetailView(vm: vm)
            }
            .task {
                await vm.fetchData()
            }
        }
    }
}
