import Foundation

extension Double {

    func toStringInt() -> String {
        return String(Int(self))
    }

    func toStringFloor1() -> String {
        return String(floor(self * 10) / 10)
    }

    func toStringFloor2() -> String {
        return String(floor(self * 100) / 100)
    }

}
