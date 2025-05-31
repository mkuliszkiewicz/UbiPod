import Observation
import os
import Network

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "NetworkMonitor")

protocol NetworkMonitoring: AnyObject, Observable {
    var hasInternetConnection: Bool { get }
}

@Observable
final class NetworkMonitor: NetworkMonitoring {
    private let networkMonitor = NWPathMonitor()
    private(set) var hasInternetConnection = true

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                guard self.hasInternetConnection != isConnected else { return }
                logger.debug("network connectivity has changed: \(isConnected, privacy: .auto)")
                self.hasInternetConnection = isConnected
            }
        }

        networkMonitor.start(queue: DispatchQueue.global(qos: .utility))
    }
}

final class ConstantNetworkMonitor: NetworkMonitoring {
    let hasInternetConnection: Bool

    init(hasInternetConnection: Bool) {
        self.hasInternetConnection = hasInternetConnection
    }
}
