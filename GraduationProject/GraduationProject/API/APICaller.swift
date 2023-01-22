//
//  APIConstants.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//


import Foundation

enum APIError: Error {
    case failedToGetData
    case failedToDecodeData
}

final class APICaller {
    
    static let shared = APICaller()
    
    func fetchGames<T: Codable>(url: String, expecting: T.Type, randomPageNumber: Int?, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        var url = url
        if let randomPageNumber = randomPageNumber {
            url = url + "&page=\(randomPageNumber)"
        }
        
        if let url = URL(string: url) {
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                
                guard let data = data, error == nil else {
                    onCompletion(.failure(.failedToGetData))
                    return
                }
                
                guard let results = try? JSONDecoder().decode(expecting.self, from: data) else {
                    onCompletion(.failure(.failedToGetData))
                    return
                }
                
                onCompletion(.success(results))
            }
            task.resume()
        }
        else {
            onCompletion(.failure(.failedToGetData))
        }
    }
    
    func fetchGamesWithSearchQuery<T: Codable>(url: String, page: Int, filter: String, query: String, expecting: T.Type, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        
        if let url = URL(string: url + query + "&ordering=" + filter + "&search_exact=true&page=" + String(page)) {
            
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                
                guard let data = data, error == nil else {
                    onCompletion(.failure(.failedToGetData))
                    return
                }
                
                guard let results = try? JSONDecoder().decode(expecting.self, from: data) else {
                    onCompletion(.failure(.failedToGetData))
                    return
                }
                
                onCompletion(.success(results))
            }
            task.resume()
        }
        else {
            onCompletion(.failure(.failedToGetData))
        }
    }
    
    func fetchSpecificGameDetails<T: Codable>(with gameId: String, expecting: T.Type, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games/\(gameId)?key=\(APIConstants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            guard let results = try? JSONDecoder().decode(T.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
    }
    
}
