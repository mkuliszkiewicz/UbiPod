@testable import UbiPod
import Observation
import Foundation
import Testing

struct RootModelTests {
    let networkMonitor = TestNetworkMonitor()
    let userDefaults = TestUserDefaults()

    @Test("when created, should set list model closure")
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

    @Test("podcast details presentation should update the navigation path")
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

    @Test("when created, should read the last selected country from user defaults")
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

    @Test("when created, and no saved country, it should default to US")
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

    @Test("changing country should update the list model")
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

    @Test("network connection state changes should be reflected in the model")
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
        try await Task.sleep(for: .seconds(3))

        #expect(!sut.hasInternetConnection)
    }
}

@Observable
final class TestNetworkMonitor: NetworkMonitoring {
    var hasInternetConnection = false
}

final class TestUserDefaults: UserDefaultsType {
    var storage: [String: Any] = [:]

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    func object(forKey defaultName: String) -> Any? {
        storage[defaultName]
    }
}
