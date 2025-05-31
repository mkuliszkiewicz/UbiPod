enum Country: String, CaseIterable, Identifiable {
    case US
    case SE
    case PL
    case LV

    var id: String {
        rawValue
    }
}
