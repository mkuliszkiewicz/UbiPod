import Foundation

protocol PodcastEpisodesLoading: AnyObject, Sendable {
    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode]
}

final class PodcastEpisodesLoader: PodcastEpisodesLoading {
    enum APIError: Swift.Error {
        case invalidUrl
        case podcastNotFound
    }

    private let loadData: LoadData

    init(loadData: @escaping LoadData) {
        self.loadData = loadData
    }

    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode] {
        guard var components = URLComponents(string: "https://itunes.apple.com/lookup") else {
            throw APIError.invalidUrl
        }

        components.queryItems = [
            URLQueryItem(name: "id", value: podcastId),
            URLQueryItem(name: "media", value: "podcast"),
            URLQueryItem(name: "entity", value: "podcastEpisode"),
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "sort", value: "recent")
        ]

        guard let url = components.url else {
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
}

/// The lookup API returns objects of different types so we need to employ a custom parsing
/// to prevent the failure of parsing of the whole array
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

        if wrapperKind == "podcastEpisode" {
            self = .episode(try PodcastEpisode(from: decoder))
        } else {
            self = .other
        }
    }
}

final class PreviewPodcastEpisodesLoader: PodcastEpisodesLoading {
    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode] {
        [
            .init(
                episodeUrl: URL(string: "https://anchor.fm/s/ff12104c/podcast/play/101980816/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2025-3-30%2F399339382-44100-2-ab95293249fc9.mp3")!,
                shortDescription: "Trójka studentów wraca z imprezy. Na monitoringu z windy wszystko wygląda spokojnie – śmiechy, chwiejne kroki, żadnych oznak konfliktu. A jednak chwilę później coś idzie bardzo nie tak. Co naprawdę wydarzyło się tamtej nocy? I dlaczego dziś tylko dwoje z nich może o tym opowiedzieć?",
                trackName: "Ostatnie nagranie z windy. Co stało się później w apartamencie? | 372.",
                id: 1000709850832,
                releaseDate: Date(),
                trackTimeMillis: 1643000
            )
        ]
    }
}
