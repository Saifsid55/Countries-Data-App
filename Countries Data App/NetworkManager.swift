//
//  NetworkManager.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//
import Foundation

protocol NetworkService {
    func fetchData<T: Codable>(from url: String, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData<T: Codable>(from urlStr: String) async throws -> T
}

class NetworkManager: NetworkService {
    static let shared = NetworkManager()
    
    private init()  {}
    
    func fetchData<T: Codable>(from urlStr: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchData<T: Codable>(from urlStr: String) async throws -> T {
        guard let url = URL(string: urlStr) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
