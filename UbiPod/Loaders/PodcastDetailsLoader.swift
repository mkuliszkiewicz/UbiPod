import Foundation

protocol PodcastDetailsLoading: AnyObject, Sendable {
    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast
}

final class PodcastDetailsLoader: PodcastDetailsLoading {
    enum APIError: Swift.Error {
        case invalidUrl
        case podcastNotFound
    }

    private let loadData: LoadData

    init(loadData: @escaping LoadData) {
        self.loadData = loadData
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
