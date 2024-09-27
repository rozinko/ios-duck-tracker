import SwiftUI
import MapKit
import MapCache

class OSMHistoryTrackMapViewDelegate: MKMapView, MKMapViewDelegate {

    // переменные для правильной отрисовки оверлеев
    var overlayTrackPointsDrawed = 0
    var overlaySelectedPointDrawed: Int?

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

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Selected")
        annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        annotationView.layer.backgroundColor = UIColor(named: "MarkerSelectedPointBackground")?.resolvedColor(with: self.traitCollection).cgColor
        annotationView.layer.borderColor = UIColor(Color.commonOrange).cgColor
        annotationView.layer.borderWidth = 7.0
        annotationView.layer.cornerRadius = 15.0
        return annotationView
    }

}

#Preview("Selected Point") {
    OSMHistoryTrackMapView(
        region: .constant(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 59.939, longitude: 30.315),
                span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            )
        ),
        trackCoordinates: [
            CLLocationCoordinate2D(latitude: 59.94, longitude: 30.312),
            CLLocationCoordinate2D(latitude: 59.95, longitude: 30.31),
            CLLocationCoordinate2D(latitude: 59.951, longitude: 30.315),
            CLLocationCoordinate2D(latitude: 59.93, longitude: 30.325)
        ],
        selectedPoint: .constant(1))
}
