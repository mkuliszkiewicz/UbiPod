@testable import UbiPod
import Observation
import Foundation
import Testing

struct RootModelTests {

    let networkMonitor = TestNetworkMonitor()
    let userDefaults = TestUserDefaults()

    @Test
    func testInit_whenCalled_shouldConfigurePodcastsListModel() async throws {
        // Arrange
        let sut = RootModel(
            selectedCountry: .PL,
            dependencies: .init(
                loadData: { _ in (Data(), URLResponse()) },
                networkMonitor: networkMonitor,
                userDefaults: userDefaults
            )
        )

        #expect(sut.path.isEmpty)

        // Act & Assert
        sut.podcastsListModel.onPresentPodcastDetails(
            .init(id: "id", name: "name", imageUrl: nil, genres: [], url: nil)
        )

        // The success is lack of assertion
    }

    @Test
    func testPresentingPodcasts_whenCalled_shouldUpdatePath() async throws {
        // Arrange
        let sut = RootModel(
            selectedCountry: .PL,
            dependencies: .init(
                loadData: { _ in (Data(), URLResponse()) },
                networkMonitor: networkMonitor,
                userDefaults: userDefaults
            )
        )

        #expect(sut.path.isEmpty)

        // Act & Assert
        await sut.presentPodcastDetails(
            podcast: .init(
                id: "id",
                name: "name",
                imageUrl: nil,
                genres: [],
                url: nil
            )
        )

        #expect(sut.path.count == 1)
    }

    @Test
    func testInit_whenCalled_shouldReadCountry() async throws {
        // Arrange
        userDefaults.storage["selected-country"] = "LV"

        let sut = RootModel(
            dependencies: .init(
                loadData: { _ in (Data(), URLResponse()) },
                networkMonitor: networkMonitor,
                userDefaults: userDefaults
            )
        )

        #expect(sut.path.isEmpty)

        // Act & Assert
        #expect(sut.selectedCountry == .LV)
    }

    @Test
    func testInit_whenCalledAndNoCountry_shouldDefaultToUS() async throws {
        // Arrange
        let sut = RootModel(
            dependencies: .init(
                loadData: { _ in (Data(), URLResponse()) },
                networkMonitor: networkMonitor,
                userDefaults: userDefaults
            )
        )

        #expect(sut.path.isEmpty)

        // Act & Assert
        #expect(sut.selectedCountry == .US)
    }

    @Test
    func testChangingCountry_whenCalled_shouldUpdateListModel() async throws {
        // Arrange
        let sut = RootModel(
            dependencies: .init(
                loadData: { _ in (Data(), URLResponse()) },
                networkMonitor: networkMonitor,
                userDefaults: userDefaults
            )
        )

        let listModel = sut.podcastsListModel
        #expect(sut.selectedCountry == .US)

        // Act & Assert
        await sut.update(selectedCountry: .PL)

        #expect(listModel.selectedCountry == .PL)
    }
}

@Observable
final class TestNetworkMonitor: NetworkMonitoring {
    var hasInternetConnection = false
}

final class TestUserDefaults: UserDefaulting {
    var storage: [String: Any] = [:]

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    func object(forKey defaultName: String) -> Any? {
        storage[defaultName]
    }
}
