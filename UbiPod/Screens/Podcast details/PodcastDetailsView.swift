import SwiftUI

protocol PodcastDetailsLoading: AnyObject {
    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast
}

protocol PodcastEpisodesLoading: AnyObject {
    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode]
}

@Observable
final class PodcastDetailsModel: HashableObject {
    let podcast: Podcast
    let podcastDetailsLoader: any PodcastDetailsLoading
    let podcastEpisodesLoader: any PodcastEpisodesLoading

    init(
        podcast: Podcast,
        podcastDetailsLoader: any PodcastDetailsLoading,
        podcastEpisodesLoader: any PodcastEpisodesLoading
    ) {
        self.podcast = podcast
        self.podcastDetailsLoader = podcastDetailsLoader
        self.podcastEpisodesLoader = podcastEpisodesLoader
    }

    convenience init(podcast: Podcast, dependencies: Dependencies) {
        let api = PodcastsAPIClient(loadData: dependencies.loadData)
        self.init(
            podcast: podcast,
            podcastDetailsLoader: api,
            podcastEpisodesLoader: api
        )
    }


    @MainActor
    func load() async {
        
    }
}

struct PodcastDetailsView: View {
    let model: PodcastDetailsModel

    var body: some View {
        VStack {
            Text("Podcast details")
        }
    }
}

// See https://github.com/pointfreeco/swiftui-navigation/blob/main/Sources/SwiftUINavigation/HashableObject.swift
// It allows to have view models as navigation destinations
protocol HashableObject: AnyObject, Hashable {}

extension HashableObject {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs === rhs }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(ObjectIdentifier(self))
  }
}
