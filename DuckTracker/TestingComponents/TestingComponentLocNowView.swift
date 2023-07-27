import SwiftUI

struct TestingComponentLocNowView: View {

    @ObservedObject var locationProvider = LocationProvider.shared

    var latitude: String { self.toStr(locationProvider.userLocation?.coordinate.latitude) }
    var longitude: String { self.toStr(locationProvider.userLocation?.coordinate.longitude) }
    var altitude: String { self.toStr(locationProvider.userLocation?.altitude) }
    var speed: String { self.toStr(locationProvider.userLocation?.speed) }
    var course: String { self.toStr(locationProvider.userLocation?.course) }

    var hAcc: String { self.toStr(locationProvider.userLocation?.horizontalAccuracy) }
    var vAcc: String { self.toStr(locationProvider.userLocation?.verticalAccuracy) }
    var sAcc: String { self.toStr(locationProvider.userLocation?.speedAccuracy) }

    func toStr(_ value: Double?) -> String {
        return value != nil ? String(value!) : " --- "
    }

    func getElement(_ title: String, _ value: String) -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 1) {
                Text(title).frame(height: 25)
                Text(value).frame(height: 25)
            }
            Spacer()
        }.background(Color.commonElementBackground)
    }

    var body: some View {

        VStack(spacing: 1) {
            HStack(spacing: 1) {
                self.getElement("lat", latitude)
                self.getElement("long", longitude)
            }

            HStack(spacing: 1) {
                self.getElement("alt", altitude)
                self.getElement("course", course)
                self.getElement("speed", speed)
            }

            HStack(spacing: 1) {
                self.getElement("vAcc", vAcc)
                self.getElement("hAcc", hAcc)
                self.getElement("sAcc", sAcc)
            }
        }
    }
}

struct TestingComponentLocNowView_Previews: PreviewProvider {
    static var previews: some View {
        TestingComponentLocNowView()
            .background(Color.gray)
    }
}
