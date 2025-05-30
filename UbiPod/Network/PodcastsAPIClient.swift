import Foundation

final class PodcastsAPIClient {

    enum APIError: Swift.Error {
        case invalidUrl
    }

    let loadData: LoadData
    init(loadData: @escaping LoadData) {
        self.loadData = loadData
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
            let results: [Podcast]
        }

        let envelope = try jsonDecoder.decode(ResponseEnvelope.self, from: data)

        return envelope.results
    }
}
