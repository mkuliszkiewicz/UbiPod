import SwiftUI

enum Destination: Hashable {
    case podcastDetails(String)
}

/// Acts as a coordinator for the app and manages the navigation.
@Observable
final class RootModel {
    var path = NavigationPath()
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
