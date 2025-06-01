import os
import Foundation

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "HTTPCall")

typealias LoadData = @Sendable (URLRequest) async throws -> (Data, URLResponse)

/// A Dependencies class is used to inject the "base" dependencies into the leaves of the application tree.
/// For example: the disk access, a 3rd party logger hidden behind an interface, clock, network monitor, user defaults etc.
/// This allows to have a full control over the application during unit tests.
final class Dependencies {
    let loadData: LoadData
    let networkMonitor: any NetworkMonitoring
    let userDefaults: any UserDefaultsType

    init(
        loadData: @escaping LoadData,
        networkMonitor: any NetworkMonitoring,
        userDefaults: any UserDefaultsType
    ) {
        self.loadData = loadData
        self.networkMonitor = networkMonitor
        self.userDefaults = userDefaults
    }
}

extension Dependencies {
    static func makeDefault() -> Dependencies {
        .init(
            loadData: { request in
                let session = URLSession.shared
                do {
                    return try await session.data(for: request)
                } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
                    do {
                        var newRequest = request
                        newRequest.cachePolicy = .returnCacheDataDontLoad
                        let (data, urlResponse) = try await session.data(for: newRequest)
                        logger.debug("serving cached response for: \(request.url?.absoluteString ?? "n/a")")
                        return (data, urlResponse)
                    } catch {
                        throw error
                    }
                } catch {
                    throw error
                }
            },
            networkMonitor: NetworkMonitor(),
            userDefaults: UserDefaults.standard
        )
    }

    static func makePreview() -> Dependencies {
        .init(
            loadData: { _ in (Data(), URLResponse()) },
            networkMonitor: ConstantNetworkMonitor(hasInternetConnection: false),
            userDefaults: PreviewUserDefaults()
        )
    }
}
