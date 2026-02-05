//
//  Country.swift
//  Countries Data App
//
//  Clean architecture domain model.
//

import Foundation

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
