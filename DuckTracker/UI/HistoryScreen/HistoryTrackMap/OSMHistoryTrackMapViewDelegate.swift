import SwiftUI
import MapKit
import MapCache

class OSMHistoryTrackMapViewDelegate: MKMapView, MKMapViewDelegate {

    // переменные для правильной отрисовки оверлеев
    var overlayTrackPointsDrawed = 0

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: CachedTileOverlay.self) {
            return mapView.mapCacheRenderer(forOverlay: overlay)
        }

        if overlay.isKind(of: MKPolyline.self) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(Color.mapViewStroke)
            renderer.lineWidth = 7.0
            return renderer
        }

        return MKOverlayRenderer()
    }

}
