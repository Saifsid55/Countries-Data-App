//
//  CountryDetailView.swift
//  Countries Data App
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(country.name.official)
                .font(.headline)
            Text(country.flag)
                .font(.largeTitle)
            Text("Capital: \(country.capital.first ?? "N/A")")
                .font(.subheadline)
        }
        .padding()
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }
}
