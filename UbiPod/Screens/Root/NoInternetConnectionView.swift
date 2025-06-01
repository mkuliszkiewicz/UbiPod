import SwiftUI

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
