//
//  Game.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import Foundation

// MARK: - Platform
struct Platform: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PlatformResult]?
}

// MARK: - PlatformResult
struct PlatformResult: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let image: String?
    let yearStart: Int?
    let yearEnd: Int?
    let games: [PlatformGame]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case image
        case yearStart = "year_start"
        case yearEnd = "year_end"
        case games
    }
}

// MARK: - PlatformGame
struct PlatformGame: Codable {
    let id: Int?
    let slug, name: String?
    let added: Int?
}
