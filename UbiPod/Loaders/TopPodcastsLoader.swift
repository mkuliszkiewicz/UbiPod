import Foundation

protocol TopPodcastsLoading: AnyObject, Sendable {
    func loadTopPodcasts(
        countryCode: String,
        limit: UInt
    ) async throws -> [Podcast]
}

final class TopPodcastsLoader: TopPodcastsLoading {
    enum APIError: Swift.Error {
        case invalidUrl
    }

    private let loadData: LoadData

    init(loadData: @escaping LoadData) {
        self.loadData = loadData
    }

    func loadTopPodcasts(
        countryCode: String,
        limit: UInt
    ) async throws -> [Podcast] {
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
