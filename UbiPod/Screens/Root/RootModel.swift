import SwiftUI

enum Destination: Hashable {
    case podcastDetails(PodcastDetailsModel)
}

/// Acts as a coordinator for the app and manages the navigation.
@Observable
final class RootModel {
    var path = NavigationPath()
    let dependencies: Dependencies
    let podcastsListModel: PodcastsListModel

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.podcastsListModel = PodcastsListModel(dependencies: dependencies)
        podcastsListModel.onPresentPodcastDetails = { [weak self] podcast in
            guard let self else { return }
            Task { @MainActor in
                self.presentPodcastDetails(podcast: podcast)
            }
        }
    }

    @MainActor
    func presentPodcastDetails(podcast: Podcast) {
        path.append(
            Destination.podcastDetails(
                PodcastDetailsModel(
                    podcast: podcast,
                    dependencies: dependencies
                )
            )
        )
    }
}
