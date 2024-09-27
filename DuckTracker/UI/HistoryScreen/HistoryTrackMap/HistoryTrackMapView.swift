import SwiftUI
import MapKit

struct HistoryTrackMapView: View {

    @Binding var region: MKCoordinateRegion

    let trackCoordinates: [CLLocationCoordinate2D]

    @Binding var selectedPoint: Int?

    // Setting Map Server
    @AppStorage("SettingMapServer") var settingMapServerRawValue: String?
    private var settingMapServer: SettingMapServer { .init(fromString: settingMapServerRawValue) }
    // End of Setting Map Server

    var body: some View {
        if settingMapServer == .osm {
            OSMHistoryTrackMapView(region: $region, trackCoordinates: trackCoordinates, selectedPoint: $selectedPoint)
        } else {
            AppleHistoryTrackMapView(region: $region, trackCoordinates: trackCoordinates, selectedPoint: $selectedPoint)
        }
    }
}

#Preview {
    HistoryTrackMapView(region: .constant(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )), trackCoordinates: [
        CLLocationCoordinate2D(latitude: 59.85, longitude: 30.38),
        CLLocationCoordinate2D(latitude: 59.89, longitude: 30.31),
        CLLocationCoordinate2D(latitude: 59.92, longitude: 30.32),
        CLLocationCoordinate2D(latitude: 59.95, longitude: 30.36),
        CLLocationCoordinate2D(latitude: 59.93, longitude: 30.31)
    ], selectedPoint: .constant(nil))
}
