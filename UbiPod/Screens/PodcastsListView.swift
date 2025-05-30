import SwiftUI

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

    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }


    func load() async {
        
    }
}

struct PodcastsListView: View {
    let model: PodcastsListModel

    var body: some View {
        LazyVStack {

        }
        .task(id: "load-podcasts-list") {

        }
    }
}
