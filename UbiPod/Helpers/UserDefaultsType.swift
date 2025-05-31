import Foundation

protocol UserDefaultsType: AnyObject {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: UserDefaultsType {}

final class PreviewUserDefaults: UserDefaultsType {
    func set(_ value: Any?, forKey defaultName: String) {}

    func object(forKey defaultName: String) -> Any? { nil }
}
