//
//  CountryDTO.swift
//  Countries Data App
//

import Foundation

/*
 DTO- (Data Transfer Object) models for API response.
 
 A DTO is a plain object used only to transfer data between layers or over the network.

 No business logic

 Mostly used for API responses / requests

 Keeps layers decoupled
 */

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
