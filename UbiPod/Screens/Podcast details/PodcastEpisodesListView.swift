import SwiftUI

struct PodcastEpisodesListView: View {
    let episodes: [PodcastEpisode]

    var body: some View {
        VStack {
            ForEach(episodes) { episode in
                PodcastEpisodeListRow(
                    title: episode.trackName,
                    subtitle: episode.shortDescription,
                    duration: episode.durationDisplayString,
                    releaseDate: episode.releaseDate.displayString
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

extension PodcastEpisode {
    var durationDisplayString: String {
        var dateComponents = DateComponents()
        dateComponents.second = trackTimeMillis / 1000
        return DateComponentsFormatter.durationFormatter.string(from: dateComponents) ?? "n/a"
    }
}
