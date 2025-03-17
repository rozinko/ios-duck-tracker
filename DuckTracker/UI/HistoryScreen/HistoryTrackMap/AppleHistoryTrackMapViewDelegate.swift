import SwiftUI
import MapKit

class AppleHistoryTrackMapViewDelegate: MKMapView, MKMapViewDelegate {

    // переменные для правильной отрисовки оверлеев
    var overlayTrackPointsDrawed = 0
    var overlaySelectedPointDrawed: Int?

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(Color.mapViewStroke)
            renderer.lineWidth = 7.0
            return renderer
        }

        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let reUseId: String
        let uiImageSystemName: String

        switch annotation.title {
        case "trackStartPoint":
            reUseId = "trackStartPoint"
            uiImageSystemName = "play.circle"
        case "trackFinishPoint":
            reUseId = "trackFinishPoint"
            if #available(iOS 16.1, *) {
                uiImageSystemName = "flag.checkered.circle"
            } else {
                uiImageSystemName = "stop.circle"
            }
        case "trackSelectedPoint":
            reUseId = "trackSelectedPoint"
            if #available(iOS 17.0, *) {
                uiImageSystemName = "mappin.and.ellipse.circle"
            } else {
                uiImageSystemName = "mappin.circle"
            }
        default:
            reUseId = "point"
            uiImageSystemName = "mappin.circle"
        }

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reUseId)
        annotationView.image = UIImage(systemName: uiImageSystemName)
        annotationView.backgroundColor = UIColor(named: "MKAnnotationBackground")
        annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        annotationView.layer.cornerRadius = 15.0
        return annotationView
    }

//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("regionDidChangeAnimated")
//    }

}

#Preview("Selected Point") {
    AppleHistoryTrackMapView(
        selectedPoint: .constant(1),
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
        ])
}
