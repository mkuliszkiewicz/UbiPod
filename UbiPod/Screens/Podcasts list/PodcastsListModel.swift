import Observation
import os

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "PodcastsListModel")

protocol TopPodcastsLoading: AnyObject {
    func loadTopPodcasts(countryCode: String, limit: UInt) async throws -> [Podcast]
}

@Observable
final class PodcastsListModel {
    var state: LoadingState<[Podcast]> = .idle

    var onPresentPodcastDetails: (Podcast) -> Void = { _ in
        assertionFailure("onPresentPodcastDetails not implemented")
    }

    private let topPodcastsLoader: any TopPodcastsLoading

    init(topPodcastsLoader: any TopPodcastsLoading) {
        self.topPodcastsLoader = topPodcastsLoader
    }

    convenience init(dependencies: Dependencies) {
        self.init(
            topPodcastsLoader: PodcastsAPIClient(
                loadData: dependencies.loadData
            )
        )
    }

    @MainActor
    func reload() async {
        state = .loading
        do {
            let podcasts = try await topPodcastsLoader.loadTopPodcasts(
                countryCode: "PL",
                limit: 10
            )
            state = .loaded(podcasts)
        } catch {
            logger.error("failed to load podcasts: \(error, privacy: .auto)")
            state = .failed
        }
    }

    @MainActor
    func firstLoad() async {
        guard state == .idle || state == .failed else { return }
        await reload()
    }

    func onPodcastTap(podcast: Podcast) {
        onPresentPodcastDetails(podcast)
    }
}
