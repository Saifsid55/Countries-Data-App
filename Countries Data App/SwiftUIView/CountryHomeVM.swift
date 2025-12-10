//
//  CountryHomeVM.swift
//  Countries Data App
//
//  Created by Mohd Saif on 10/12/25.
//

import SwiftUI
import Combine

class CountryHomeVM: ObservableObject {
    @Published var countriesData: [Countries]?
    @Published var selectedCountry: Countries?
    var url = APIConfig.baseURL//"https://restcountries.com/v3.1/independent?status=true&fields=languages,capital,flag,name"
    var networkService: NetworkService
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func fetchData() async {
        do {
            let result: [Countries] = try await networkService.fetchData(from: url)
            countriesData = result
            print(countriesData ?? [])
        }
        catch {
            print("Error:", error)
        }
    }
}
