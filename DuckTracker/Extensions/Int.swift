import Foundation

extension Int {

    public func toStringWithDeclension(one: String, two: String, five: String) -> String {
        let d1 = self % 10
        let d2 = self % 100

        var result = String(self) + " "

        if (d2 >= 11 && d2 <= 20) || d1 == 0 || d1 >= 5 {
            result += five.localized()
        } else if d1 >= 2 {
            result += two.localized()
        } else {
            result += one.localized()
        }

        return result
    }

}
