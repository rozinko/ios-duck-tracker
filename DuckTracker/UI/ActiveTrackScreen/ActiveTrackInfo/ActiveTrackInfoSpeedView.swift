import SwiftUI

struct ActiveTrackInfoSpeedView: View {

    @ObservedObject private var locationProvider = LocationProvider.shared

    var body: some View {
        TrackInfoCircleView(
            title: ".speed".localized().uppercased(),
            text: locationProvider.userLocation != nil ? locationProvider.userLocation!.speed.prepareStringKmh(withUnit: false) : "-",
            unit: ".kmh".localized().uppercased())
    }
}

struct ActiveTrackInfoSpeedView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackInfoSpeedView()
    }
}
