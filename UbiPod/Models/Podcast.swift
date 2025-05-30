import Foundation

struct Podcast: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let imageUrl: URL?
    let genres: [Genre]
    let url: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name = "artistName"
        case imageUrl = "artworkUrl100"
        case genres
        case url
    }
}

struct Genre: Identifiable, Hashable, Decodable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "genreId"
        case name
    }
}
