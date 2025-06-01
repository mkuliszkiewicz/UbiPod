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

final class PreviewPodcastDetailsLoader: PodcastDetailsLoading, @unchecked Sendable {

    struct LocalError: Swift.Error {}

    var result: Result<DetailedPodcast, Error>

    convenience init() {
        self.init(
            result: .success(
                .init(
                    id: 1403172116,
                    name: "Kryminatorium",
                    imageUrl: URL(
                        string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/600x600bb.jpg"
                    )!,
                    releaseDate: Date(),
                    trackCount: 100
                )
            )
        )
    }

    init(result: Result<DetailedPodcast, Error>) {
        self.result = result
    }

    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast {
        try result.get()
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

final class PreviewPodcastsLoader: TopPodcastsLoading, @unchecked Sendable {

    struct LocalError: Swift.Error {}

    var result: Result<[Podcast], Error>

    init(result: Result<[Podcast], Error>) {
        self.result = result
    }

    convenience init() {
        self.init(
            result: .success([
                UbiPod.Podcast(
                    id: "1403172116",
                    name: "Kryminatorium",
                    imageUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/100x100bb.png"),
                    genres: [
                        UbiPod.Genre(id: "1488", name: "True Crime")
                    ],
                    url: URL(string: "https://podcasts.apple.com/pl/podcast/kryminatorium/id1403172116")
                ),
                UbiPod.Podcast(
                    id: "1702830056",
                    name: "zurnalistapl",
                    imageUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts221/v4/83/b7/7a/83b77a6a-ae9d-f3c2-0120-cd52ce2d7be0/mza_14804989242152802187.jpg/100x100bb.png"),
                    genres: [
                        UbiPod.Genre(
                            id: "1324",
                            name: "Society & Culture"
                        )
                    ], url: URL(string: "https://podcasts.apple.com/pl/podcast/%C5%BCurnalista-rozmowy-bez-kompromis%C3%B3w/id1702830056")
                )
            ]
                            )
        )
    }

    func loadTopPodcasts(
        countryCode: String,
        limit: UInt
    ) async throws -> [Podcast] {
        try result.get()
    }
}
