import SwiftUI

@Observable
final class RootModel: @unchecked Sendable {
    var path = NavigationPath()
    let dependencies: Dependencies
    let podcastsListModel: PodcastsListModel

    private(set) var hasInternetConnection = true
    private(set) var selectedCountry: Country

    convenience init(dependencies: Dependencies) {
        self.init(
            selectedCountry: dependencies.userDefaults.userSelectedCountry,
            dependencies: dependencies
        )
    }

    init(selectedCountry: Country, dependencies: Dependencies) {
        self.selectedCountry = selectedCountry
        self.dependencies = dependencies
        self.podcastsListModel = PodcastsListModel(
            selectedCountry: selectedCountry,
            dependencies: dependencies
        )

        podcastsListModel.onPresentPodcastDetails = { [weak self] podcast in
            guard let self else { return }
            Task {
                await self.presentPodcastDetails(podcast: podcast)
            }
        }

        observeInternetConnection()
    }

    private func observeInternetConnection() {
        withObservationTracking({ [weak self] in
            guard let self else { return }
            self.hasInternetConnection = dependencies.networkMonitor.hasInternetConnection
        }) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.observeInternetConnection()
            }
        }
    }

    @MainActor
    func update(selectedCountry newCountry: Country) async {
        guard selectedCountry != newCountry else { return }
        selectedCountry = newCountry
        dependencies.userDefaults.userSelectedCountry = newCountry
        await podcastsListModel.update(country: newCountry)
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

extension UserDefaultsType {
    var userSelectedCountry: Country {
        get {
            guard
                let countryCode = object(forKey: "selected-country") as? String,
                let country = Country(rawValue: countryCode)
            else {
                return .US
            }

            return country
        }
        set {
            set(newValue.rawValue, forKey: "selected-country")
        }
    }
}

enum Destination: Hashable {
    case podcastDetails(PodcastDetailsModel)
}
