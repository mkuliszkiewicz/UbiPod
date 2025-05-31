import Foundation

extension DateFormatter {
    static let displayDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
}

extension Date {
    var displayString: String {
        DateFormatter.displayDateFormatter.string(from: self)
    }
}
