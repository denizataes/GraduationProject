import Foundation

// MARK: - Genre
struct Genre: Codable {
    let count: Int?
    let next, previous: String?
    let results: [GenreResult]?
}

// MARK: - GenreResult
struct GenreResult: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let games: [GenreGame]?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case games
    }
}

// MARK: - GenreGame
struct GenreGame: Codable {
    let id: Int?
    let slug, name: String?
    let added: Int?
}
