import SwiftUI
import MapKit

struct ActiveTrackMapView: View {

    @Binding var activeTrackMapRegion: MKCoordinateRegion

    @ObservedObject var activeTrackProvider = ActiveTrackProvider.shared

    // Setting Map Server
    @AppStorage("SettingMapServer") var settingMapServerRawValue: String?
    private var settingMapServer: SettingMapServer { .init(fromString: settingMapServerRawValue) }
    // End of Setting Map Server

    var body: some View {
        if settingMapServer == .osm {
            OSMActiveTrackMapView(
                mapRegion: $activeTrackMapRegion,
                isRecordingMode: activeTrackProvider.isRecording,
                showUserLocation: true,
                showUserTrackingButton: true,
                trackCoordinates: activeTrackProvider.track.trackCoordinates)
        } else {
            AppleActiveTrackMapView(
                mapRegion: $activeTrackMapRegion,
                isRecordingMode: activeTrackProvider.isRecording,
                showUserLocation: true,
                showUserTrackingButton: true,
                trackCoordinates: activeTrackProvider.track.trackCoordinates)
        }
    }
}

struct ActiveTrackMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTrackMapView(activeTrackMapRegion: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )))
    }
}
