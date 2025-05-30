import SwiftUI

struct PodcastListRow: View {
    let name: String
    let genres: [String]
    let imageUrl: URL?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.system(.headline).weight(.semibold))
                    .foregroundStyle(.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(genres.joined(separator: ", "))
                    .font(.system(.callout).weight(.light))
                    .foregroundStyle(.textSecondary)
                    .lineLimit(1)
            }

            if let imageUrl {
                Spacer()
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        Color.secondary
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.secondary
                    @unknown default:
                        Color.secondary
                    }
                }
                .frame(width: 50, height: 50)
            }

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
    PodcastListRow(
        name: "Very long name - Very long name Very long name",
        genres: ["Genre 1", "Genre 2", "Genre 3", "Genre 4", "Genre 5", "Genre 6", "Genre 7"],
        imageUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts221/v4/83/b7/7a/83b77a6a-ae9d-f3c2-0120-cd52ce2d7be0/mza_14804989242152802187.jpg/100x100bb.png"),
    )
}
