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
    
    func fetchGamesWithPage<T: Codable>(url: String, expecting: T.Type, pageNumber: Int, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&ordering=-added&page_size=20&page=\(pageNumber)") else { return }
        
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
    
    func fetchGamesByGenre<T: Codable>(url: String, genreID: Int, expecting: T.Type, pageNumber: Int, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games?key=\(APIConstants.API_KEY)&genres=\(genreID)&ordering=-added&page_size=20&page=\(pageNumber)") else { return }
        
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
    
    
//    func searchGames(with query: String, page: Int, onCompletion: @escaping (Result<[GameResult], APIError>) -> Void) {
//        var url = APIConstants.BASE_URL + "&page_size=20&page=\(page)"
//
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//
//        guard let url = URL(string: "\(url)&search=\(query)") else { return }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
//            guard let data = data, error == nil else {
//                onCompletion(.failure(.failedToGetData))
//                return
//            }
//
//            guard let results = try? JSONDecoder().decode(GamesResponse.self, from: data) else {
//                onCompletion(.failure(.failedToGetData))
//                return
//            }
//
//            onCompletion(.success(results.results ?? []))
//        }
//        task.resume()
//    }
    
    
    func fetchMainGameDetails(with gameId: String, onCompletion: @escaping (Result<GameDetail, APIError>) -> Void) {
        
        guard let url = URL(string: "\(APIConstants.BASE_URL)/games/\(gameId)?key=\(APIConstants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            guard let results = try? JSONDecoder().decode(GameDetail.self, from: data) else {
                onCompletion(.failure(.failedToGetData))
                return
            }
            
            onCompletion(.success(results))
        }
        task.resume()
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
    
    func fetchPlatform<T: Codable>(url: String, expecting: T.Type, randomPageNumber: Int?, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        
        var url = url
        if let randomPageNumber = randomPageNumber {
            url = url + "&page=\(randomPageNumber)"
        }
        
        guard let url = URL(string: url) else { return }
        
        
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
    
    func fetchGenres<T: Codable>(url: String, expecting: T.Type, onCompletion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: url) else { return }
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
