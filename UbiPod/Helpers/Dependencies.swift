import os
import Foundation

// In reality this is all we need 
typealias LoadData = (URLRequest) async throws -> (Data, URLResponse)

/// A Dependencies class is used to inject the "base" dependencies into the leaves of the application tree.
/// For example: the disk access, a 3rd party logger hidden behind an interface, clock, network monitor, user defaults etc.
/// This allows to have a full control over the application during unit tests.
final class Dependencies {
    let loadData: LoadData
    let networkMonitor: any NetworkMonitoring
    let userDefaults: any UserDefaulting

    init(
        loadData: @escaping LoadData,
        networkMonitor: any NetworkMonitoring,
        userDefaults: any UserDefaulting
    ) {
        self.loadData = loadData
        self.networkMonitor = networkMonitor
        self.userDefaults = userDefaults
    }
}

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "HTTPCall")

extension Dependencies {
    static func makeDefault() -> Dependencies {
        .init(
            loadData: { request in
                let (data, urlResponse) = try await URLSession.shared.data(for: request)

#if DEBUG
                let responseHeaders = (urlResponse as? HTTPURLResponse)?.allHeaderFields ?? [:]
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                let formattedJson = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                let responseJson = String(bytes: formattedJson, encoding: .utf8) ?? "n/a"
                logger
                    .debug("Request: \(request.url?.absoluteString ?? "n/a", privacy: .auto)\nResponse:\n\(responseHeaders, privacy: .auto)\n\(responseJson, privacy: .private)")
#endif

                return (data, urlResponse)
            },
            networkMonitor: NetworkMonitor(),
            userDefaults: UserDefaults.standard
        )
    }
}
