import Foundation

struct PodcastEpisode: Decodable, Hashable, Identifiable {
    let episodeUrl: URL
    let shortDescription: String
    let trackName: String
    let id: Int64
    let releaseDate: Date // "2025-05-26T03:00:00Z"
    let trackTimeMillis: Int64

    enum CodingKeys: String, CodingKey {
        case episodeUrl
        case shortDescription
        case trackName
        case id = "trackId"
        case releaseDate
        case trackTimeMillis
    }
}
