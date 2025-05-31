import SwiftUI

/// Handles the chrome of the app
struct RootView: View {
    let model: RootModel

    var body: some View {
        // This dance is needed to feed a binding to the NavigationStack
        @Bindable var model = model
        NavigationStack(path: $model.path) {
            PodcastsListView(
                model: model.podcastsListModel
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

        if !model.hasInternetConnection {
            HStack(spacing: 0) {
                Image(systemName: "network.slash")
                Text("You are not connected to the internet")
                    .font(.footnote)
                    .foregroundStyle(.textHint)
                    .padding()
            }
            .containerRelativeFrame([.horizontal], alignment: .center)
        }
    }
}

#Preview {
    RootView(
        model: .init(
            selectedCountry: .PL,
            dependencies: .makePreview()
        )
    )
    .background(Color.backgroundSurface)
}

extension Dependencies {
    static func makePreview() -> Dependencies {
        .init(
            loadData: { _ in
                return (Data(), URLResponse())
            },
            networkMonitor: ConstantNetworkMonitor(hasInternetConnection: false),
            userDefaults: UserDefaults(suiteName: "preview")!
        )
    }
}

