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

        // Act
        await sut.update(selectedCountry: .PL)

        // Assert
        #expect(listModel.selectedCountry == .PL)
    }

    @Test
    func testNetworkObservation_whenChanges_shouldUpdateProperty() async throws {
        // Arrange
        networkMonitor.hasInternetConnection = true

        let sut = RootModel(
            dependencies: .init(
                loadData: { _ in (Data(), URLResponse()) },
                networkMonitor: networkMonitor,
                userDefaults: userDefaults
            )
        )

        #expect(sut.hasInternetConnection)

        // Act & Assert
        networkMonitor.hasInternetConnection = false

        // I would use MainSerialExecutor.swift from pointfree here
        // https://github.com/pointfreeco/swift-concurrency-extras/blob/main/Sources/ConcurrencyExtras/MainSerialExecutor.swift
        // But this sleep should be enough for the demo app
        try await Task.sleep(nanoseconds: 3_000_000_0)

        #expect(!sut.hasInternetConnection)
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
