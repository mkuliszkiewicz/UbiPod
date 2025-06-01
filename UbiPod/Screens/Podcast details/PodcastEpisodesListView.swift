import SwiftUI

struct PodcastEpisodesListView: View {
    let episodes: [PodcastEpisode]

    var body: some View {
        VStack {
            ForEach(episodes) { episode in
                PodcastEpisodeListRow(
                    title: episode.trackName,
                    subtitle: episode.shortDescription,
                    duration: episode.durationDisplayString ?? "n/a",
                    releaseDate: episode.releaseDate.formatted(date: .long, time: .shortened)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(episode.accessibilityLabel)
            }
        }
    }
}

extension PodcastEpisode {
    var durationDisplayString: String? {
        guard let trackTimeMillis else { return nil }
        var dateComponents = DateComponents()
        dateComponents.second = trackTimeMillis / 1000
        return DateComponentsFormatter.durationFormatter.string(from: dateComponents)
    }

    var accessibilityLabel: String {
        "Podcast episode: \(trackName), released: \(releaseDate.formatted(date: .complete, time: .omitted)), duration: \(durationDisplayString ?? "n/a")"
    }
}
