//
//  Country.swift
//  Countries Data App
//
//  Clean architecture domain model.
//

import Foundation

/// Domain entity used by presentation and business layers.
///
/// File responsibility:
/// - Hold country data in app-friendly shape.
/// - Stay independent from API details.
///
/// File connections:
/// - Created from DTO mapping in `Data/DTOs/CountryDTO.swift`.
/// - Used by use case, view models, and views.
struct Country: Hashable, Identifiable {
    var id: String {name.official}
    let name: CountryName
    let capital: [String]
    let languages: [String: String]
    let flag: String
}

struct CountryName: Hashable {
    let common: String
    let official: String
}
