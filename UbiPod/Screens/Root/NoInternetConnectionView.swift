import SwiftUI

struct NoInternetConnectionView: View {
    var body: some View {
        Label(
            "No internet connection",
            systemImage: "network.slash"
        )
        .containerRelativeFrame([.horizontal], alignment: .center)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("No internet connection")
        .imageScale(.medium)
    }
}

#Preview {
    NoInternetConnectionView()
}
