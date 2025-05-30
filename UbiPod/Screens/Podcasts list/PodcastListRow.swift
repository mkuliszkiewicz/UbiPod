import SwiftUI

struct PodcastListRow: View {
    let name: String

    var body: some View {
        VStack(spacing: 0) {
            Text(name)
                .font(.system(.title3))
        }
        .background(Color.cardBackground)
    }
}

#Preview {
    PodcastListRow(name: "Name")
}
