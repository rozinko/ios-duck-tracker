import CoreLocation

extension CLLocationDistance {

    func toKm() -> Double {
        return self / 1000
    }

    func prepareString() -> String {
        if self < 1000 {
            let unit = ".m".localized()
            return (self <= 0 ? "0" : self.toStringInt()) + " " + unit
        }

        let value = self.toKm()
        let unit = ".km".localized()

        return (value < 10 ? value.toStringFloor2() : (value < 100 ? value.toStringFloor1() : value.toStringInt())) + " " + unit
    }

}
