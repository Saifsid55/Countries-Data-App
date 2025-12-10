//
//  HomeViewModel.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//

import Foundation

protocol HomeView {
    var countriesData: [Countries]? {get set}
    var url: String {get}
    var networkService: NetworkService {get set}
    var didFetchData: (()->Void)? {get set}
    var numberOfCountries: Int {get}
    func dataByIndex(index: Int) -> Countries?
    func fetchCountries()
}

class HomeViewModel: HomeView {
    var countriesData: [Countries]?
    var url = "https://restcountries.com/v3.1/independent?status=true&fields=languages,capital,flag,name"
    var networkService: NetworkService
    var didFetchData: (()->Void)?
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    var numberOfCountries: Int {
        return countriesData?.count ?? 0
    }
    
    func dataByIndex(index: Int) -> Countries? {
         return countriesData?[index]
    }
    
    
    
    func fetchCountries() {
        networkService.fetchData(from: url) { [weak self] (result: (Result<[Countries], Error>)) in
            guard let self = self else {return}
            switch result {
            case .success(let countries):
                print(countries)
                countriesData = countries
                didFetchData?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
