import Foundation

final class PodcastsAPIClient: TopPodcastsLoading, PodcastDetailsLoading, PodcastEpisodesLoading {
    enum APIError: Swift.Error {
        case invalidUrl
        case podcastNotFound
    }

    private let loadData: LoadData

    init(loadData: @escaping LoadData) {
        self.loadData = loadData
    }

    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode] {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(podcastId)&media=podcast&entity=podcastEpisode&limit=20&sort=recent") else {
            throw APIError.invalidUrl
        }

        let request = URLRequest(url: url, timeoutInterval: 5)

        let (data, _) = try await loadData(request)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        struct ResponseEnvelope: Decodable {
            let results: [EpisodesParsingHelper]
        }

        let envelope = try jsonDecoder.decode(ResponseEnvelope.self, from: data)

        return envelope.results.compactMap(\.episode)
    }

    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(podcastId)") else {
            throw APIError.invalidUrl
        }

        let request = URLRequest(url: url, timeoutInterval: 5)

        let (data, _) = try await loadData(request)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        struct ResponseEnvelope: Decodable {
            let results: [DetailedPodcast]
        }

        let envelope = try jsonDecoder.decode(ResponseEnvelope.self, from: data)

        guard let detailedPodcast = envelope.results.first else {
            throw APIError.podcastNotFound
        }

        return detailedPodcast
    }

    func loadTopPodcasts(countryCode: String, limit: UInt) async throws -> [Podcast] {
        guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/\(countryCode)/podcasts/top/\(limit)/podcasts.json") else {
            throw APIError.invalidUrl
        }

        let request = URLRequest(url: url, timeoutInterval: 5)

        let (data, _) = try await loadData(request)

        let jsonDecoder = JSONDecoder()

        // Important note:
        // In a real life scenario a domain mapping here would occur, so I would map response objects
        // to the local domain objects. But due to the time constraint I've decided to skip it.
        struct ResponseEnvelope: Decodable {
            struct Feed: Decodable {
                let results: [Podcast]
            }
            let feed: Feed
        }

        let envelope = try jsonDecoder.decode(ResponseEnvelope.self, from: data)

        return envelope.feed.results
    }
}

private enum EpisodesParsingHelper: Decodable {
    case other
    case episode(PodcastEpisode)

    var episode: PodcastEpisode? {
        switch self {
        case .other: nil
        case .episode(let podcastEpisode): podcastEpisode
        }
    }

    enum CodingKeys: String, CodingKey {
        case wrapperType
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrapperKind = try container.decode(String.self, forKey: .wrapperType)

        // The lookup API returns objects of different types so we need to employ a custom parsing
        if wrapperKind == "podcastEpisode" {
            self = .episode(try PodcastEpisode(from: decoder))
        } else {
            self = .other
        }
    }
}
