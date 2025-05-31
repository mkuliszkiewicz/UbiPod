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

    var selectedCountry: Country {
        didSet {
            guard oldValue != selectedCountry else { return }
            dependencies.userDefaults.userSelectedCountry = selectedCountry
            
            Task {
                await self.podcastsListModel.update(country: self.selectedCountry)
            }
        }
    }

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

extension UserDefaulting {
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
