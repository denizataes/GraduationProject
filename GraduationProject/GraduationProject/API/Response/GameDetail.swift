//
//  Game.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import Foundation

struct GameDetail: Codable {
    let name: String?
    let background_image: String?
    let description_raw: String?
    let rating: Double?
    let ratings: [GameRating]
    let released: String?
    let playtime: Int?
    let platforms: [PlatformElement]?
    let genres: [GenreResult]?
}
