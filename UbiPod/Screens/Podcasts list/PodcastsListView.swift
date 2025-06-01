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
                                    subtitle: podcast.genresDisplayString,
                                    imageUrl: podcast.imageUrl
                                )
                                .accessibilityElement(children: .ignore)
                            }
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 8,
                                    style: .continuous
                                )
                            )
                            .padding(.horizontal)
                            .accessibilityHint("Double tap to show details")
                            .accessibilityLabel(podcast.accessibilityLabel)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await model.reload()
                }
            case .failed:
                ContentUnavailableView {
                    Label(
                        "Unable to load podcast",
                        systemImage: "x.circle"
                    )
                    .font(.title)
                } description: {
                    Text("Check your internet connection")
                        .padding()
                } actions: {
                    Button("Try again") {
                        Task {
                            await model.reload()
                        }
                    }
                }
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

extension Podcast {
    var genresDisplayString: String {
        genres.map(\.name).joined(separator: ", ")
    }

    var accessibilityLabel: String {
        "Podcast: " + name + ", " + genresDisplayString
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
