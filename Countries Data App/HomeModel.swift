//
//  HomeModel.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//
import Foundation

struct Countries: Codable, Hashable  {
//    var id = UUID()
    let name: Name
    let capital: [String]
    let languages: [String: String]
    let flag: String
}

struct Name: Codable, Hashable {
    let common: String
    let official: String
}
