@testable import UbiPod
import Foundation
import Testing

@MainActor
struct PodcastsListModelTests {
    let podcastsLoader = TestTopPodcastsLoader()

    @Test("if state is idle, should execute the first load")
    func testFirstLoad_whenStateIsIdle_shouldLoad() async throws {
        // Arrange
        let sut = PodcastsListModel(
            selectedCountry: .PL,
            topPodcastsLoader: podcastsLoader
        )

        #expect(sut.state == .idle)

        podcastsLoader.result = .success(
            [
                .init(
                    id: "expected-id",
                    name: "name",
                    imageUrl: nil,
                    genres: [],
                    url: nil
                )
            ]
        )

        // Act
        await sut.firstLoad()

        // Assert
        #expect(sut.state.content?.first?.id == "expected-id")
    }

    @Test("if state is failed, should execute the first load")
    func testFirstLoad_whenStateIsFailed_shouldLoad() async throws {
        // Arrange
        let sut = PodcastsListModel(
            selectedCountry: .PL,
            topPodcastsLoader: podcastsLoader
        )

        sut.state = .failed

        podcastsLoader.result = .success(
            [
                .init(
                    id: "expected-id",
                    name: "name",
                    imageUrl: nil,
                    genres: [],
                    url: nil
                )
            ]
        )

        // Act
        await sut.firstLoad()

        // Assert

        #expect(sut.state.content?.first?.id == "expected-id")
    }

    @Test("if state is loading, should NOT execute the first load")
    func testFirstLoad_whenStateIsLoading_shouldNotLoad() async throws {
        // Arrange
        let sut = PodcastsListModel(
            selectedCountry: .PL,
            topPodcastsLoader: podcastsLoader
        )

        sut.state = .loading

        podcastsLoader.result = .success(
            [
                .init(
                    id: "expected-id",
                    name: "name",
                    imageUrl: nil,
                    genres: [],
                    url: nil
                )
            ]
        )

        // Act
        await sut.firstLoad()

        // Assert
        #expect(sut.state == .loading)
    }

    @Test("when loading, should use provided country")
    func testReload_whenCalled_shouldPassCountry() async throws {
        // Arrange
        let sut = PodcastsListModel(
            selectedCountry: .LV,
            topPodcastsLoader: podcastsLoader
        )

        // Act
        await sut.reload()

        // Assert
        #expect(podcastsLoader.countryCode == Country.LV.rawValue)
        #expect(podcastsLoader.limit == 10)
    }

    @Test("when loading fails, it should update state")
    func testReload_whenFails_shouldUpdateState() async throws {
        // Arrange
        let sut = PodcastsListModel(
            selectedCountry: .LV,
            topPodcastsLoader: podcastsLoader
        )

        struct LocalError: Swift.Error {}

        podcastsLoader.result = .failure(LocalError())

        // Act
        await sut.reload()

        // Assert
        #expect(sut.state == .failed)
    }

    @Test("when updating the selected country it should reload the data")
    func testUpdateCountry_whenCalled_shouldUpdateAndReload() async throws {
        // Arrange
        let sut = PodcastsListModel(
            selectedCountry: .LV,
            topPodcastsLoader: podcastsLoader
        )

        #expect(sut.selectedCountry == .LV)

        // Act
        await sut.update(country: .SE)

        // Assert
        #expect(sut.selectedCountry == .SE)
    }
}

final class TestTopPodcastsLoader: TopPodcastsLoading, @unchecked Sendable {
    var result: Result<[Podcast], Error> = .success([])

    var countryCode: String?
    var limit: UInt?

    func loadTopPodcasts(
        countryCode: String,
        limit: UInt
    ) async throws -> [Podcast] {
        self.countryCode = countryCode
        self.limit = limit
        return try result.get()
    }
}
