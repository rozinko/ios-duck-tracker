import SwiftUI
import MapKit
import MapCache

struct OSMHistoryTrackMapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion

    let trackCoordinates: [CLLocationCoordinate2D]

    @Binding var selectedPoint: Int?

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
        // удаляем старый оверлей
        uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })
        // добавляем обновленный оверлей
        let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
        overlayTrack.title = "track"
        uiView.insertOverlayAboveLast(overlayTrack)

        // удаляем все точки
        uiView.removeAnnotations(uiView.annotations)
        // добавляем выбранную точку с графика, если она есть
        if selectedPoint != nil && selectedPoint! < trackCoordinates.count {
            let selectedAnnotation = MKPointAnnotation()
            selectedAnnotation.coordinate = trackCoordinates[selectedPoint!]
            selectedAnnotation.title = "SelectedPoint"
            uiView.addAnnotation(selectedAnnotation)
        }

        mapView.setRegion(region, animated: true)
    }

}
