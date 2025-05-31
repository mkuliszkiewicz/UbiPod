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
                        await model.load()
                    }
                }
            }
        }
        .toolbarRole(.editor) // hides a back button title
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.backgroundSurface)
        .task {
            await model.load()
        }
    }
}

struct PodcastDetailsHeaderView: View {
    let detailedPodcast: DetailedPodcast

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(
                url: detailedPodcast.imageUrl,
                transaction: Transaction(animation: .smooth)
            ) { phase in
                switch phase {
                case .empty, .failure:
                    EmptyView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)

            Text(detailedPodcast.name)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textPrimary)

            Text("Episodes: \(detailedPodcast.trackCount)")
                .font(.headline.weight(.light))
                .foregroundStyle(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Latest episode: \(detailedPodcast.releaseDate.displayString)")
                .font(.headline.weight(.light))
                .foregroundStyle(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
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

final class PreviewPodcastDetailsLoader: PodcastDetailsLoading {
    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast {
        .init(
            id: 1403172116,
            name: "Kryminatorium",
            imageUrl: URL(
                string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts211/v4/63/b7/3b/63b73b95-3e7a-4515-4434-55d041005ce3/mza_5485170451367603359.jpg/600x600bb.jpg"
            )!,
            releaseDate: Date(),
            trackCount: 100
        )
    }
}

final class PreviewPodcastEpisodesLoader: PodcastEpisodesLoading {
    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode] {
        [
            .init(
                episodeUrl: URL(string: "https://anchor.fm/s/ff12104c/podcast/play/101980816/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2025-3-30%2F399339382-44100-2-ab95293249fc9.mp3")!,
                shortDescription: "Trójka studentów wraca z imprezy. Na monitoringu z windy wszystko wygląda spokojnie – śmiechy, chwiejne kroki, żadnych oznak konfliktu. A jednak chwilę później coś idzie bardzo nie tak. Co naprawdę wydarzyło się tamtej nocy? I dlaczego dziś tylko dwoje z nich może o tym opowiedzieć?",
                trackName: "Ostatnie nagranie z windy. Co stało się później w apartamencie? | 372.",
                id: 1000709850832,
                releaseDate: Date(),
                trackTimeMillis: 1643000
            )
        ]
    }
}
