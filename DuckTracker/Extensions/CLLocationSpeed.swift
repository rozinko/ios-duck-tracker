import CoreLocation

extension CLLocationSpeed {

    func toKmh() -> Double {
        return self * 3.6
    }

    func prepareStringKmh(withUnit: Bool = true) -> String {
        let value = self.toKmh()
        let unit = ".kmh".localized()

        return (value <= 0 ? "0.0" : (value < 100 ? value.toStringFloor1() : value.toStringInt())) + (withUnit ? " " + unit : "")
    }

}
