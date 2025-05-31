import os
import SwiftUI

struct PodcastsListView: View {
    let model: PodcastsListModel

    var body: some View {
        VStack(spacing: 0) {
            switch model.state {
            case .loading, .idle:
                LoadingView()
            case .loaded(let podcasts):
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(podcasts) { podcast in
                            Button(action: {
                                model.onPodcastTap(
                                    podcast: podcast
                                )
                            }) {
                                PodcastListRow(
                                    title: podcast.name,
                                    subtitle: podcast.genres.map(\.name).joined(separator: ", "),
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
                    .padding(.vertical)
                }
                .refreshable {
                    await model.reload()
                }
            case .failed:
                ErrorView(
                    reason: "Unable to load podcasts",
                    onTryAgain: {
                        Task {
                            await model.reload()
                        }
                    }
                )
            }
        }
        .animation(.easeInOut, value: model.state)
        .background(Color.backgroundSurface)
        .task(id: "load-podcasts-list") {
            await model.firstLoad()
        }
        .navigationTitle("Top podcasts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PodcastsListView(
            model: .init(
                selectedCountry: .US,
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
