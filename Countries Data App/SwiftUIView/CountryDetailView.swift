//
//  CountryDetailView.swift
//  Countries Data App
//
//  Created by Mohd Saif on 10/12/25.
//

import SwiftUI

struct CountryDetailView: View {
    @ObservedObject var vm: CountryHomeVM
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.selectedCountry?.name.official ?? "No name")
            Text(vm.selectedCountry?.flag ?? "No Flag")
//            Text(country.languages.first?.value)
        }
    }
}
