import Observation
import os
import Network

private let logger = os.Logger(subsystem: "com.kuliszkiewicz.ubipod", category: "NetworkMonitor")

protocol NetworkMonitoring: AnyObject, Observable {
    var isConnected: Bool { get }
}

final class ConstantNetworkMonitor: NetworkMonitoring {
    let isConnected: Bool

    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}

@Observable
final class NetworkMonitor: NetworkMonitoring {
    var isConnected: Bool {
        get { hasNetworkConnection.withLock({ $0 }) }
    }

    private let networkMonitor = NWPathMonitor()
    private let hasNetworkConnection = OSAllocatedUnfairLock(initialState: true)

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.hasNetworkConnection.withLock { value in
                logger.debug("network connectivity has changed: \(path.status == .satisfied, privacy: .auto)")
                self.withMutation(keyPath: \.isConnected) {
                    value = path.status == .satisfied
                }
            }
        }

        networkMonitor.start(queue: DispatchQueue.global(qos: .utility))
    }
}
