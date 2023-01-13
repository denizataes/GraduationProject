//
//  Game.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import Foundation

struct GameDetail: Codable {
    let name: String?
    let slug: String
    let background_image: String?
    let description_raw: String?
    let metacritic: Int?
    let rating: Double?
    let ratings: [Rating]
    let genres: [Genres]
    let developers: [Developers]
    let released: String?
    let publishers: [Publishers]
}

struct Rating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

struct Genres: Codable {
    let name: String
}

struct Developers: Codable {
    let name: String
}

struct Publishers: Codable {
    let name: String
}
