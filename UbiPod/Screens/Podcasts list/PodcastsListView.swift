import SwiftUI

@Observable
final class PodcastsListModel {
    enum State: Hashable {
        case loading
        case loaded([Podcast])
        case failed

        var isLoaded: Bool {
            switch self {
            case .loading:
                false
            case .loaded:
                true
            case .failed:
                false
            }
        }
    }

    var state: State = .loading

    private let dependencies: Dependencies
    private let apiClient: PodcastsAPIClient

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.apiClient = PodcastsAPIClient(loadData: dependencies.loadData)
    }

    @MainActor
    func load() async {
        guard state != .loading else { return }
        state = .loading
        do {
            let podcasts = try await apiClient.loadTopPodcasts(countryCode: "PL", limit: 50)
            state = .loaded(podcasts)
        } catch {
            state = .failed
        }
    }
}

struct PodcastsListView: View {
    let model: PodcastsListModel

    var body: some View {
        VStack(spacing: 0) {
            switch model.state {
            case .loading:
                ProgressView()
            case .loaded(let podcasts):
                LazyVStack {
                    ForEach(podcasts) { podcast in
                        PodcastListRow(name: podcast.name)
                    }
                }
            case .failed:
                ErrorView(reason: "Unable to load podcasts")
            }
        }
        .task(id: "load-podcasts-list") {
            await model.load()
        }
    }
}
