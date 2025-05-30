import Foundation

struct PodcastEpisode: Decodable {
    let episodeUrl: URL
    let description: String
    let trackName: String
    let id: Int
    let releaseDate: Date // "2025-05-26T03:00:00Z"
    let trackTimeMillis: Int64

    enum CodingKeys: String, CodingKey {
        case episodeUrl
        case description
        case trackName
        case id = "trackId"
        case releaseDate
        case trackTimeMillis
    }
}
