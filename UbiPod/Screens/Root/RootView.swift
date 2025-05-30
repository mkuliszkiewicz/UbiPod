import SwiftUI

/// Handles the chrome of the app
struct RootView: View {
    let rootModel: RootModel
    var body: some View {
        NavigationStack {
            EmptyView()
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
