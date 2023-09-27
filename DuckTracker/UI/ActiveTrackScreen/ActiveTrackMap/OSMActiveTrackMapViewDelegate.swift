import SwiftUI
import MapKit
import MapCache

class OSMActiveTrackMapViewDelegate: MKMapView, MKMapViewDelegate {

    // переменная для присвоения userTrackingMode один раз в начале отображения карты
    private var firstUserTrackingModeSetted = false

    // переменные для правильной отрисовки оверлеев
    var overlayTrackPointsDrawed = 0
    var overlayTrackToUserLocationDrawed = false

    func annotationUserLocation(annotation: MKAnnotation) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.image = UIImage(named: "MarkerUserLocationDuck")
        return annotationView
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // устанавливаем UserTrackingMode = .followWithHeading если это первый вызов mapViewDidFinishLoadingMap()
        // и ставим метку true в переменную
        if !firstUserTrackingModeSetted {
            firstUserTrackingModeSetted = true
            mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return annotationUserLocation(annotation: annotation)
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: CachedTileOverlay.self) {
            return mapView.mapCacheRenderer(forOverlay: overlay)
        }

        if overlay.isKind(of: MKPolyline.self) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "MapViewStroke")!
            renderer.lineWidth = 7.0
            return renderer
        }

        return MKOverlayRenderer()
    }

}
