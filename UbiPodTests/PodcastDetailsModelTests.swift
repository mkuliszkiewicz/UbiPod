@testable import UbiPod
import Foundation
import Testing

@MainActor
struct PodcastDetailsModelTests {
    let podcastDetailsLoader = TestPodcastDetailsLoader()
    let podcastEpisodesLoader = TestPodcastEpisodesLoader()

    struct LocalError: Swift.Error {}

    @Test("when loading of podcast details fails, the whole page loading should fail")
    func testLoad_whenLoadingDetailsFails_shouldFail() async throws {
        // Arrange
        let sut = PodcastDetailsModel(
            podcast: .init(
                id: "id",
                name: "name",
                imageUrl: nil,
                genres: [],
                url: nil
            ),
            podcastDetailsLoader: podcastDetailsLoader,
            podcastEpisodesLoader: podcastEpisodesLoader
        )
        podcastDetailsLoader.result = .failure(LocalError())
        #expect(sut.state == .idle)

        // Act
        await sut.firstLoad()

        // Assert
        #expect(sut.state == .failed)
    }

    @Test("when loading of podcast episodes fails, the whole page loading should fail")
    func testLoad_whenLoadingEpisodesFails_shouldFail() async throws {
        // Arrange
        let sut = PodcastDetailsModel(
            podcast: .init(
                id: "id",
                name: "name",
                imageUrl: nil,
                genres: [],
                url: nil
            ),
            podcastDetailsLoader: podcastDetailsLoader,
            podcastEpisodesLoader: podcastEpisodesLoader
        )
        podcastEpisodesLoader.result = .failure(LocalError())
        #expect(sut.state == .idle)

        // Act
        await sut.firstLoad()

        // Assert
        #expect(sut.state == .failed)
    }

    @Test("when loading of details and episodes succeeds, should succeed")
    func testLoad_whenLoadingSucceeds_shouldUpdateState() async throws {
        // Arrange
        let sut = PodcastDetailsModel(
            podcast: .init(
                id: "podcast-id",
                name: "name",
                imageUrl: nil,
                genres: [],
                url: nil
            ),
            podcastDetailsLoader: podcastDetailsLoader,
            podcastEpisodesLoader: podcastEpisodesLoader
        )
        // Act
        await sut.firstLoad()

        // Assert
        #expect(sut.state.content != nil)
        #expect(podcastDetailsLoader.podcastId == "podcast-id")
        #expect(podcastEpisodesLoader.podcastId == "podcast-id")
    }
}

final class TestPodcastDetailsLoader: PodcastDetailsLoading, @unchecked Sendable {
    var podcastId: String?
    var result: Result<DetailedPodcast, Error> = .success(
        .init(
            id: 123,
            name: "name",
            imageUrl: URL(string: "https://")!,
            releaseDate: Date(),
            trackCount: 0
        )
    )

    func loadPodcastDetails(podcastId: String) async throws -> DetailedPodcast {
        self.podcastId = podcastId
        return try result.get()
    }
}

final class TestPodcastEpisodesLoader: PodcastEpisodesLoading, @unchecked Sendable {
    var podcastId: String?
    var result: Result<[PodcastEpisode], Error> = .success([])

    func loadPodcastEpisodes(podcastId: String) async throws -> [PodcastEpisode] {
        self.podcastId = podcastId
        return try result.get()
    }
}
