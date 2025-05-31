import Foundation

protocol UserDefaulting: AnyObject {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: UserDefaulting {}

final class PreviewUserDefaults: UserDefaulting {
    func set(_ value: Any?, forKey defaultName: String) {

    }

    func object(forKey defaultName: String) -> Any? {
        nil
    }
}
