import SwiftUI
import MapKit
import MapCache

struct OSMHistoryTrackMapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion

    let trackCoordinates: [CLLocationCoordinate2D]

    private let mapView = OSMHistoryTrackMapViewDelegate()

    func makeUIView(context: UIViewRepresentableContext<OSMHistoryTrackMapView>) -> OSMHistoryTrackMapViewDelegate {
        mapView.delegate = mapView

        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true

        mapView.showsScale = true
        mapView.showsCompass = true

        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none

        mapView.setRegion(region, animated: true)

        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        let mapCache = MapCache(withConfig: config)
        mapView.useCache(mapCache)

        return mapView
    }

    func updateUIView(_ uiView: OSMHistoryTrackMapViewDelegate, context: UIViewRepresentableContext<OSMHistoryTrackMapView>) {
        // удаляем старый
        uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })
        // добавляем обновленный
        let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
        overlayTrack.title = "track"
        uiView.insertOverlayAboveLast(overlayTrack)

        mapView.setRegion(region, animated: true)
    }

}
