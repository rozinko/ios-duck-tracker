import SwiftUI
import MapKit

struct HistoryTrackMapView: View {

    @Binding var region: MKCoordinateRegion

    let trackCoordinates: [CLLocationCoordinate2D]

    var body: some View {
        AppleHistoryTrackMapView(region: $region, trackCoordinates: trackCoordinates)
    }
}

struct HistoryTrackMapView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTrackMapView(region: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )), trackCoordinates: [
            CLLocationCoordinate2D(latitude: 59.85, longitude: 30.38),
            CLLocationCoordinate2D(latitude: 59.89, longitude: 30.31),
            CLLocationCoordinate2D(latitude: 59.92, longitude: 30.32),
            CLLocationCoordinate2D(latitude: 59.95, longitude: 30.36),
            CLLocationCoordinate2D(latitude: 59.93, longitude: 30.31)
        ])
    }
}
