import SwiftUI
import Foundation
import os

@MainActor private let dependencies: Dependencies = .makeDefault()
@MainActor private let rootModel = RootModel(dependencies: dependencies)

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
        if NSClassFromString("XCTestCase") != nil || ProcessInfo.processInfo.environment["XCTestBundlePath"] != nil {
            TestApp.main()
        } else {
            UbiPodApp.main()
        }
    }
}

struct UbiPodApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(model: rootModel)
                .background(Color.backgroundSurface)
        }
    }
}
