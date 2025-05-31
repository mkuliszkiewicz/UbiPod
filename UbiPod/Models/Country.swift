import Foundation

enum Country: String, CaseIterable, Identifiable {
    case US
    case SE
    case PL
    case LV

    var id: String {
        rawValue
    }

    var accessibilityName: String {
        Locale.autoupdatingCurrent.localizedString(forRegionCode: self.rawValue) ?? rawValue
    }
}
