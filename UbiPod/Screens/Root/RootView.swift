import SwiftUI

/// Handles the chrome of the app and country selection
struct RootView: View {
    let model: RootModel

    var body: some View {
        // This dance is needed to feed the path binding to the NavigationStack
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
                            Task {
                                await model.update(selectedCountry: country)
                            }
                        } label: {
                            Label(title: {
                                Text(country.rawValue)
                                    .accessibilityAddTraits(country == model.selectedCountry ? [.isSelected] : [])
                                    .accessibilityLabel(country.accessibilityName)
                            }) {
                                if country == model.selectedCountry {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                .accessibilityLabel("Current country: \(model.selectedCountry.accessibilityName)")
                .accessibilityHint("Use to change the top podcasts country")
            }
        }

        if !model.hasInternetConnection {
            NoInternetConnectionView()
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

struct NoInternetConnectionView: View {
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "network.slash")
            Text("No internet connection")
                .font(.footnote)
                .foregroundStyle(.textHint)
                .padding()
        }
        .containerRelativeFrame([.horizontal], alignment: .center)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("No internet connection")
    }
}
