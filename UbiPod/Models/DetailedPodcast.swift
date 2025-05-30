import Foundation

struct DetailedPodcast: Decodable, Hashable {
    let id: Int
    let name: String
    let imageUrl: URL
    let releaseDate: Date
    let trackCount: Int

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case name = "artistName"
        case imageUrl = "artworkUrl600"
        case releaseDate
        case trackCount
    }
}
