import SwiftUI

struct PodcastEpisodesListView: View {
    let episodes: [PodcastEpisode]

    var body: some View {
        VStack {
            ForEach(episodes) { episode in
                PodcastEpisodeListRow(
                    title: episode.trackName,
                    subtitle: episode.shortDescription
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                )
            }
        }
    }
}
