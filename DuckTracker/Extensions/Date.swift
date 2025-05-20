import Foundation
import SwiftUI

extension Date {

    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func toStringDate() -> String {
        return toString(dateFormat: "yyyy-MM-dd")
    }

    func toStringDayMonthYear() -> String {
        return toString(dateFormat: "dd.MM.yyyy")
    }

    func toStringDay() -> String {
        return toString(dateFormat: "d")
    }

    func toStringMonth() -> String {
        return toString(dateFormat: "MMM")
    }

    func toStringYear() -> String {
        return toString(dateFormat: "yyyy")
    }

    func toStringHHmm() -> String {
        return toString(dateFormat: "HH:mm")
    }

}

#Preview {
    Text(Date().toStringDate())
    Text(Date().toStringDayMonthYear())
    Text(Date().toStringDay())
    Text(Date().toStringMonth())
    Text(Date().toStringYear())
    Text(Date().toStringHHmm())
}
