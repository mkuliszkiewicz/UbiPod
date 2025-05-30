import SwiftUI

/// Handles the chrome of the app
struct RootView: View {
    let rootModel: RootModel

    var body: some View {
        // This dance is needed to feed a binding to the NavigationStack
        @Bindable var model = rootModel
        NavigationStack(path: $model.path) {
            PodcastsListView(
                model: rootModel.podcastsListModel
            )
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .podcastDetails(let model):
                    PodcastDetailsView(model: model)
                }
            }
            .toolbar {
                Button("Help") {
                    print("Help tapped!")
                }
            }
        }
    }
}

#Preview {
    RootView(
        rootModel: .init(
            dependencies: .makePreview()
        )
    )
}

extension Dependencies {
    static func makePreview() -> Dependencies {
        .init(
            loadData: { _ in
                return (Data(), URLResponse())
            },
            networkMonitor: ConstantNetworkMonitor(isConnected: true)
        )
    }
}
