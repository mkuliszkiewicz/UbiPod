import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading")
            .symbolEffect(.pulse)
            .controlSize(.extraLarge)
            .font(.system(.headline).bold())
            .foregroundStyle(.textHint)
            .containerRelativeFrame(
                [.horizontal, .vertical],
                alignment: .center
            )
            .accessibilityLabel("Loading data")
    }
}

#Preview {
    LoadingView()
}
