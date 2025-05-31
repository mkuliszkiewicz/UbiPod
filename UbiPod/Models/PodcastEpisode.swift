import Foundation

struct PodcastEpisode: Decodable, Hashable, Identifiable {
    let episodeUrl: URL
    let shortDescription: String
    let trackName: String
    let id: Int64
    let releaseDate: Date
    let trackTimeMillis: Int?

    enum CodingKeys: String, CodingKey {
        case episodeUrl
        case shortDescription
        case trackName
        case id = "trackId"
        case releaseDate
        case trackTimeMillis
    }
}
