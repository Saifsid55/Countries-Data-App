//
//  CountryDTO.swift
//  Countries Data App
//

import Foundation

/// DTO models for API response.
///
/// File responsibility:
/// - Represent raw JSON structure from the countries API.
/// - Convert API models to domain entities using `toDomain()`.
///
/// File connections:
/// - Decoded by `URLSessionNetworkClient` through `CountryRepositoryImpl`.
/// - Mapped to `Country` in `Domain/Entities/Country.swift`.
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
