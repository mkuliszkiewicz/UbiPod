import Observation
import os

protocol PodcastDetailsLoading: AnyObject, Sendable {
    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast
}

protocol PodcastEpisodesLoading: AnyObject, Sendable {
    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode]
}

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "PodcastDetailsModel")

@Observable
final class PodcastDetailsModel: HashableObject {
    private let podcast: Podcast
    private let podcastDetailsLoader: any PodcastDetailsLoading
    private let podcastEpisodesLoader: any PodcastEpisodesLoading

    struct ViewData: Hashable {
        let detailedPodcast: DetailedPodcast
        let episodes: [PodcastEpisode]
    }

    private(set) var state: LoadingState<ViewData> = .idle
    let title: String

    init(
        podcast: Podcast,
        podcastDetailsLoader: any PodcastDetailsLoading,
        podcastEpisodesLoader: any PodcastEpisodesLoading
    ) {
        self.podcast = podcast
        self.podcastDetailsLoader = podcastDetailsLoader
        self.podcastEpisodesLoader = podcastEpisodesLoader
        self.title = podcast.name
    }

    convenience init(podcast: Podcast, dependencies: Dependencies) {
        let api = PodcastsAPIClient(loadData: dependencies.loadData)
        self.init(
            podcast: podcast,
            podcastDetailsLoader: api,
            podcastEpisodesLoader: api
        )
    }

    @MainActor
    func reload() async {
        state = .loading
        do {
            let detailedPodcast = try await podcastDetailsLoader.loadPodcastDetails(podcastId: podcast.id)
            let episodes = try await podcastEpisodesLoader.loadPodcastEpisodes(podcastId: podcast.id)
            state = .loaded(
                .init(
                    detailedPodcast: detailedPodcast,
                    episodes: episodes
                )
            )
        } catch {
            logger.error("failed to load podcast details: \(error, privacy: .auto)")
            state = .failed
        }
    }

    @MainActor
    func firstLoad() async {
        guard state == .idle || state == .failed else { return }
        await reload()
    }
}
