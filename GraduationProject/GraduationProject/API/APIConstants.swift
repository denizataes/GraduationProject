//
//  APIConstants.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import Foundation

struct APIConstants {
    
    static let API_KEY = "57a90afafca045ae801f5df813ad7274"
    static let BASE_URL = "https://api.rawg.io/api"
    
    static let DISCOVER_URL = "\(BASE_URL)/games?key=\(API_KEY)&ordering=-added&page_size=20"
    static let METACRITIC_URL = "\(BASE_URL)/games?key=\(API_KEY)&dates=2000-01-01,2022-12-31&ordering=-metacritic&page_size=20"
    static let LATEST_URL = "\(BASE_URL)/games?key=\(API_KEY)&dates=2022-12-01,2023-01-31&ordering=-added&page_size=20"
    static let POPULAR_URL = "\(BASE_URL)/games?key=\(API_KEY)&dates=2022-01-01,2023-01-15&ordering=-added&page_size=20"
    static let SEARCH_URL = "\(BASE_URL)/games?key=\(API_KEY)&page_size=20&search="
    static let PLATFORM_URL = "\(BASE_URL)/platforms?key=\(API_KEY)"
    static let GENRE_URL = "\(BASE_URL)/genres?key=\(API_KEY)"
    
}
