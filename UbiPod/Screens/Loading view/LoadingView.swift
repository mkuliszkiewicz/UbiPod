import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading")
            .controlSize(.extraLarge)
            .font(.system(.headline).bold())
            .foregroundStyle(.textHint)
    }
}

#Preview {
    LoadingView()
}
