//
//  CountryRepository.swift
//  Countries Data App
//

import Foundation

protocol CountryRepository {
    func fetchCountries() async throws -> [Country]
}
