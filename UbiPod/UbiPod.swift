import SwiftUI
import Foundation
import os

// It is somewhat controversial to create the dependencies instance here
// but for the sake
private let dependencies: Dependencies = .makeDefault()
private let rootModel = RootModel(dependencies: dependencies)

@main
struct MainEntryPoint {
    struct TestApp: App {
        var body: some Scene {
            WindowGroup {
                Rectangle()
                    .background(Color.accentColor)
            }
        }
    }

    static func main() {
        // Avoid running the main app during unit tests
        if NSClassFromString("XCTestCase") == nil {
            UbiPodApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct UbiPodApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(rootModel: rootModel)
        }
    }
}
