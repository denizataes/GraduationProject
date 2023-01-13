//
//  Game.swift
//  GameApp
//
//  Created by Deniz Ata Eş on 12.01.2023.
//

import Foundation

struct GamesResponse: Codable {
    let results: [Game]
}

struct Game: Codable {
    let name: String
    let slug: String
    let background_image: String
    let metacritic: Int?
    var gameState: String?
}
