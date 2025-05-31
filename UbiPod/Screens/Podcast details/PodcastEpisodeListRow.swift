import SwiftUI

struct PodcastEpisodeListRow: View {
    let title: String
    let subtitle: String
    let duration: String
    let releaseDate: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline).weight(.semibold))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.leading)

            Text(subtitle)
                .font(.system(.footnote).weight(.light))
                .foregroundStyle(.textSecondary)
                .lineLimit(5, reservesSpace: true)

            Text("Duration: " + duration)
                .font(.system(.caption2).weight(.bold))
                .foregroundStyle(.textSecondary)

            Text("Release date: " + releaseDate)
                .font(.system(.caption2).weight(.bold))
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
        subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        duration: "1m 50s",
        releaseDate: "28.10.90"
    )
}
