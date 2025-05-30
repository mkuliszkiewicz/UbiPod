import SwiftUI

struct PodcastListRow: View {
    let name: String
    let genres: [String]
    let imageUrl: URL?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.system(.title3).weight(.semibold))
                    .foregroundStyle(.textPrimary)
                    .lineLimit(2)

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
                        Color.red
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 100, height: 100)
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
        name: "Name",
        genres: ["Genre 1", "Genre 2"],
        imageUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts221/v4/83/b7/7a/83b77a6a-ae9d-f3c2-0120-cd52ce2d7be0/mza_14804989242152802187.jpg/100x100bb.png"),
    )
}
