import SwiftUI
import MapKit

class AppleActiveTrackMapViewDelegate: MKMapView, MKMapViewDelegate {

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

        // TODO: требуется для рендера точек на маршруте
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
//        let course = (annotation.subtitle!! as NSString).doubleValue
//        if annotation.title == "filtered" {
//            annotationView.image = UIImage(named: "MarkerArrowRedUp")!.rotate(degrees: course)
//        } else if annotation.title == "track" {
//            annotationView.image = UIImage(named: "MarkerArrowGreenUp")!.rotate(degrees: course)
//        } else {
//            annotationView.image = UIImage(named: "MarkerArrowYellowUp")!.rotate(degrees: course)
//        }
//        return annotationView

        return nil
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(named: "MapViewStroke")!
        renderer.lineWidth = 7.0
        return renderer
    }

}
