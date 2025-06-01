import SwiftUI

struct PodcastDetailsView: View {
    let model: PodcastDetailsModel

    var body: some View {
        VStack(spacing: 0) {
            switch model.state {
            case .idle, .loading:
                LoadingView()
            case .loaded(let viewData):
                ScrollView {
                    VStack(spacing: 24) {
                        PodcastDetailsHeaderView(
                            detailedPodcast: viewData.detailedPodcast
                        )
                        PodcastEpisodesListView(
                            episodes: viewData.episodes
                        )
                    }
                    .padding(.horizontal)
                }
            case .failed:
                ErrorView(reason: "Unable to load podcast details") {
                    Task {
                        await model.firstLoad()
                    }
                }
            }
        }
        .animation(.easeInOut, value: model.state)
        .toolbarRole(.editor) // hides a back button title
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.backgroundSurface)
        .task {
            await model.firstLoad()
        }
        .refreshable {
            await model.reload()
        }
    }
}

#Preview {
    NavigationStack {
        PodcastDetailsView(
            model: .init(
                podcast: .init(
                    id: "1403172116",
                    name: "Kryminatorium",
                    imageUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/600x600bb.jpg"),
                    genres: [.init(id: "1488", name: "True Crime")],
                    url: nil
                ),
                podcastDetailsLoader: PreviewPodcastDetailsLoader(),
                podcastEpisodesLoader: PreviewPodcastEpisodesLoader()
            )
        )
    }

}
