import SwiftUI

struct PodcastDetailsHeaderView: View {
    let detailedPodcast: DetailedPodcast

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(
                url: detailedPodcast.imageUrl,
                transaction: Transaction(animation: .smooth)
            ) { phase in
                switch phase {
                case .empty, .failure:
                    EmptyView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)

            Text(detailedPodcast.name)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textPrimary)

            Text("Episodes: \(detailedPodcast.trackCount)")
                .font(.subheadline.weight(.light))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textSecondary)

            Text("Latest episode release date: \(detailedPodcast.releaseDate.displayString)")
                .font(.subheadline.weight(.light))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.textSecondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(detailedPodcast.accessibilityLabel)
    }
}
