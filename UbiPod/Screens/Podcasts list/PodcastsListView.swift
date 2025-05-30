import os
import SwiftUI

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "PodcastsListModel")

protocol TopPodcastsLoading: AnyObject {
    func loadTopPodcasts(countryCode: String, limit: UInt) async throws -> [Podcast]
}

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
    func load() async {
        state = .loading
        do {
            let podcasts = try await topPodcastsLoader.loadTopPodcasts(
                countryCode: "PL",
                limit: 10
            )
            state = .loaded(podcasts)
        } catch {
            logger.error("failed to load podcasts: \(error.localizedDescription, privacy: .auto)")
            state = .failed
        }
    }

    func onPodcastTap(podcast: Podcast) {

    }
}

struct PodcastsListView: View {
    let model: PodcastsListModel

    var body: some View {
        VStack(spacing: 0) {
            switch model.state {
            case .loading:
                LoadingView()
            case .loaded(let podcasts):
                ScrollView {
                    LazyVStack {
                        ForEach(podcasts) { podcast in
                            Button(action: {
                                model.onPodcastTap(
                                    podcast: podcast
                                )
                            }) {
                                PodcastListRow(
                                    name: podcast.name,
                                    genres: podcast.genres.map(
                                        \.name
                                    ),
                                    imageUrl: podcast.imageUrl
                                )
                            }


                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 8,
                                    style: .continuous
                                )
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .refreshable {
                    await model.load()
                }
            case .failed:
                ErrorView(reason: "Unable to load podcasts")
            }
        }
        .background(Color.backgroundSurface)
        .task(id: "load-podcasts-list") {
            await model.load()
        }
        .navigationTitle("Top podcasts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PodcastsListView(
            model: .init(
                topPodcastsLoader: PreviewPodcastsLoader()
            )
        )
    }
}

final class PreviewPodcastsLoader: TopPodcastsLoading {
    func loadTopPodcasts(countryCode: String, limit: UInt) async throws -> [Podcast] {
        [
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
    }
}
