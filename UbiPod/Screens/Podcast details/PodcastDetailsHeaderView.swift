import SwiftUI

struct PodcastDetailsHeaderView: View {
    let detailedPodcast: DetailedPodcast

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(
                url: detailedPodcast.imageUrl
            ) { phase in
                switch phase {
                case .empty:
                    EmptyView()
                case .failure:
                    Color.cardBackground
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                )
            )

            Text(detailedPodcast.name)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textPrimary)
                .padding(.vertical)

            Text("Episodes: \(detailedPodcast.trackCount)")
                .font(.subheadline.weight(.light))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textSecondary)

            Text("Latest episode release date: \(detailedPodcast.releaseDate.formatted(date: .long, time: .shortened))")
                .font(.subheadline.weight(.light))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textSecondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(detailedPodcast.accessibilityLabel)
    }
}

extension DetailedPodcast {
    var accessibilityLabel: String {
        "Podcast: \(name), episodes: \(trackCount), latest episode release date: \(releaseDate.formatted(date: .complete, time: .omitted))"
    }
}

#Preview {
    ZStack {
        Color.backgroundSurface.ignoresSafeArea()

        PodcastDetailsHeaderView(
            detailedPodcast: .init(
                id: 1,
                name: "Name",
                imageUrl: URL(
                    string: "https://"
                )!,
                releaseDate: .now,
                trackCount: 1
            )
        )
        .padding()
    }
}
