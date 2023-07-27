import SwiftUI
import MapKit

class AppleHistoryTrackMapViewDelegate: MKMapView, MKMapViewDelegate {

    // переменные для правильной отрисовки оверлеев
    var overlayTrackPointsDrawed = 0

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(Color.mapViewStroke)
        renderer.lineWidth = 7.0
        return renderer
    }

//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("regionDidChangeAnimated")
//    }

}
