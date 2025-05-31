import SwiftUI

struct PodcastEpisodeListRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline).weight(.semibold))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.leading)

            Text(subtitle)
                .font(.system(.callout).weight(.light))
                .foregroundStyle(.textSecondary)
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(Color.cardBackground)
    }
}

#Preview {
    PodcastEpisodeListRow(
        title: "Very long name - Very long name Very long name",
        subtitle: ["Genre 1", "Genre 2", "Genre 3", "Genre 4", "Genre 5", "Genre 6", "Genre 7"].joined(separator: ",")
    )
}
