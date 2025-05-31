import Observation
import os

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "PodcastsListModel")

protocol TopPodcastsLoading: AnyObject {
    func loadTopPodcasts(
        countryCode: String,
        limit: UInt
    ) async throws -> [Podcast]
}

@Observable
final class PodcastsListModel {
    var onPresentPodcastDetails: (Podcast) -> Void = { _ in
        assertionFailure("onPresentPodcastDetails not implemented")
    }

    private let topPodcastsLoader: any TopPodcastsLoading
    private(set) var selectedCountry: Country
    var state: LoadingState<[Podcast]> = .idle

    init(
        selectedCountry: Country,
        topPodcastsLoader: any TopPodcastsLoading
    ) {
        self.selectedCountry = selectedCountry
        self.topPodcastsLoader = topPodcastsLoader
    }

    convenience init(
        selectedCountry: Country,
        dependencies: Dependencies
    ) {
        self.init(
            selectedCountry: selectedCountry,
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
                countryCode: selectedCountry.rawValue,
                limit: 10
            )
            state = .loaded(podcasts)
        } catch {
            logger.error("failed to load podcasts: \(error, privacy: .auto)")
            state = .failed
        }
    }

    @MainActor
    func update(country newCountry: Country) async {
        self.selectedCountry = newCountry
        await reload()
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
