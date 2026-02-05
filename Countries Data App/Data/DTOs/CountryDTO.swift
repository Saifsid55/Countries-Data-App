//
//  CountryDTO.swift
//  Countries Data App
//

import Foundation

struct CountryDTO: Codable {
    let name: CountryNameDTO
    let capital: [String]
    let languages: [String: String]
    let flag: String

    func toDomain() -> Country {
        Country(
            name: CountryName(common: name.common, official: name.official),
            capital: capital,
            languages: languages,
            flag: flag
        )
    }
}

struct CountryNameDTO: Codable {
    let common: String
    let official: String
}
