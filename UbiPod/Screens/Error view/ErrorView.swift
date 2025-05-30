import SwiftUI

struct ErrorView: View {
    let reason: String

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .symbolEffect(.scale)

            Text(reason)
                .font(.system(.headline).bold())
        }
        .foregroundStyle(.textHint)
        .containerRelativeFrame(
            [.horizontal, .vertical],
            alignment: .center
        )
    }
}

#Preview {
    ErrorView(reason: "Unable to load podcasts")
}
