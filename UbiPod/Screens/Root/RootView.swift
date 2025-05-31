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
                Menu(model.selectedCountry.rawValue) {
                    ForEach(Country.allCases) { country in
                        Button {
                            model.selectedCountry = country
                        } label: {
                            Label(title: {
                                Text(country.rawValue)
                            }) {
                                if country == model.selectedCountry {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    
    RootView(
        rootModel: .init(
            selectedCountry: .PL,
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
            networkMonitor: ConstantNetworkMonitor(isConnected: true),
            userDefaults: UserDefaults(suiteName: "preview")!
        )
    }
}

