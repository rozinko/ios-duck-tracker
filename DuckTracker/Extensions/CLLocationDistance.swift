import CoreLocation
import SwiftUI

extension CLLocationDistance {

    func toKm() -> Double {
        return self / 1000
    }

    func prepareString(compact: Bool = false) -> String {
        let value: Double
        let unit: String

        let valueString: String
        let spaceString: String = compact ? "" : " "
        let unitString: String

        if self < 1000 {
            // meters
            value = self
            unit = ".m"
            valueString = self <= 0 ? "0" : value.toStringInt()
            unitString = unit.localized()
        } else {
            // kilometers
            value = self.toKm()
            unit = ".km"
            switch value {
            case 0 ..< 10:
                valueString = compact ? value.toStringFloor1() : value.toStringFloor2()
                unitString = unit.localized()
            case 10 ..< 100:
                valueString = compact ? value.toStringInt() : value.toStringFloor1()
                unitString = unit.localized()
            case 100 ..< 1000:
                valueString = value.toStringInt()
                unitString = unit.localized()
            default:
                valueString = value.toStringInt()
                unitString = compact ? "" : unit.localized()
            }
        }

        return valueString + spaceString + unitString
    }

}

#Preview {
    let previewData: [CLLocationDistance] = [
        // m
        1, 2.05, 5, 9.99, 15, 99.9, 100, 500, 999,
        // km
        1000, 1009, 1010, 1050, 1100, 1500, 3999, 4111, 9999,
        // 10k km
        10000, 10010, 10100, 15999, 99999, 10000,
        // 100k+ km
        100100, 101100, 999999, 1000000, 1000100
    ].map { CLLocationDistance($0) }

    ForEach(previewData, id: \.self) { dist in
        HStack {
            Text(String(dist))
            Spacer()
            Text(dist.prepareString())
            Spacer()
            Text(dist.prepareString(compact: true))
        }.padding([.leading, .trailing], 25)
    }
}
